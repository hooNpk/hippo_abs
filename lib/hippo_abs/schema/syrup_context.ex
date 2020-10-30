defmodule HippoAbs.SyrupContext do
  @moduledoc """
  The Service context.
  """

  import Ecto.Query, warn: false
  alias HippoAbs.Repo

  alias HippoAbs.Service.Syrup.{Prescription, DrugReferences, Dosage, Drugs}
  alias HippoAbs.Account

  require Logger


  def list_prescriptions, do: Repo.all(Prescription) |> Repo.preload(:dosage)

  def list_prescriptions(%Account.User{} = user), do: list_prescriptions_by_user(user)

  defp list_prescriptions_by_user(user) do
    Ecto.assoc(user, :prescription)
    |> Repo.all()
    |> Repo.preload(:dosage)
    # |> Repo.preload(:user)
    # |> Repo.preload(:doctor)
  end

  def list_dosage do
    Dosage
    |> Repo.all()
    |> Repo.preload(:prescription)
    |> Repo.preload(:drug_references)
  end

  def list_dosage_by(prescriptions) when is_list(prescriptions) do
    # Logger.warn inspect prescriptions

    prescriptions
    |> Enum.map(&list_dosage_by/1)
  end

  def list_dosage_by(prescription) do
    Ecto.assoc(prescription, :dosage)
    |> Repo.all()
    |> Repo.preload(:drug_references)
  end

  def list_drugs(term, limit, offset) do
      query =
        from d in Drugs,
          where: like(d.item_nm, ^"%#{term}%"),
          limit: ^limit,
          offset: ^offset,
          select: map(d, [:id, :item_nm, :distributor]),
          order_by: [asc: :id]
      Repo.all(query)

      # Drugs
      # |> where([d], like(d.item_nm, ^"%#{term}%"))
      # |> limit(^limit)
      # |> select([:id, :item_nm])
      # |> Repo.all()
  end

  def list_drug_references, do: DrugReferences |> Repo.all()

  def list_drug_references(dosage) do
    Ecto.assoc(dosage, :drug_references)
    |> Repo.all()
    # |> Repo.preload(:drug)
    # |> Repo.preload(:dosage)
  end

  def get_drug(id), do: Drugs |> Repo.get(id)

  def get_prescription(id), do: Repo.get(Prescription, id) |> Repo.preload(:dosage)

  def get_prescription_by(user, id) do
    query = from p in Ecto.assoc(user, :prescription), where: p.id == ^id
    query
    |> Repo.one()
    |> Repo.preload(:dosage)
end

  def get_dosage(id), do: Repo.get(Dosage, id)

  def get_dosage_by(prescription, id) do
    Ecto.assoc(prescription, :dosage)
    |> Repo.get(id)
  end

  def create_prescription(%Account.User{} = user, %Account.User{} = doctor, attrs \\ %{}) do
    changes_prescription(user, doctor, attrs)
    |> Repo.insert()
  end

  def changes_prescription(%Account.User{} = user, %Account.User{} = doctor, attrs \\ %{}) do
    %Prescription{}
    |> Prescription.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Ecto.Changeset.put_assoc(:doctor, doctor)
  end

  def create_dosage(prescription, dosage) when is_list(dosage) do
    Tuple.append({:ok},
      Enum.map(dosage, fn item ->
        {:ok, dosage} = create_dosage(prescription, item)
        dosage
      end)
    )
  end

  def create_dosage(prescription, attrs) do
    changeset_dosage(prescription, attrs)
    |> Repo.insert(on_conflict: :nothing)
  end

  def changeset_dosage(prescription, attrs) do
    %Dosage{}
    |> Dosage.changeset(prescription, attrs)
  end

  def create_dosage_multi(prescription, dosage_attrs) do
    dosage_attrs
    |> Stream.map(fn dosage_attr ->
      changeset_dosage(prescription, dosage_attr)
    end)
    |> Stream.map(fn dosage_changeset ->
      key = "dosage:#{dosage_changeset.changes.name}"
      Ecto.Multi.insert(Ecto.Multi.new(), key, dosage_changeset)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> Repo.transaction()
    |> case do
      {:ok, dosage} -> {:ok, Enum.map(dosage, fn {_k, v} -> v.id end)}
      {:error, _key, changeset, _errors} -> {:error, changeset}
    end
  end

  def create_prescription_and_dosage(user, doctor, prescription_attrs, dosage_attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:insert_prescription, changes_prescription(user, doctor, prescription_attrs))
    |> Ecto.Multi.run(:insert_pills, fn _repo, %{insert_prescription: prescription} ->

      dosage_attrs
      |> Stream.map(fn dosage_attr ->
        changeset_dosage(prescription, dosage_attr)
      end)
      |> Stream.map(fn dosage_changeset ->
        key = "dosage:#{dosage_changeset.changes.name}"
        Ecto.Multi.insert(Ecto.Multi.new(), key, dosage_changeset)
      end)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> Repo.transaction()
      |> case do
        {:ok, _prescription} -> {:ok, prescription}
        {:error, _failed_operation, failed_value, _changes_so_far} -> {:error, failed_value}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, prescription} -> {:ok, prescription.insert_prescription |> Repo.preload(:dosage)}
      {:error, _failed_operation, failed_value, _changes_so_far} -> {:error, failed_value}
    end
  end

  def create_drug_references(dosage_id, drug_refs) when is_list(drug_refs) do
    Stream.map(drug_refs, fn drug_ref ->
      %DrugReferences{}
      |> DrugReferences.changeset(%{dosage_id: dosage_id, drug_id: drug_ref["drug_id"], amount: drug_ref["amount"]})
    end)
    |> Stream.map(fn changeset ->
      key = "changeset:#{changeset.changes.drug_id}"
      Ecto.Multi.insert(Ecto.Multi.new(), key, changeset, returning: [:id])
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> Repo.transaction()
    |> case do
      {:ok, drugrefs} -> {:ok, Enum.map(drugrefs, fn {_k, v} -> v.id end)}
      {:error, _failed_operation, failed_value, _changes_so_far} -> {:error, failed_value}
    end
  end

  # def create_drug_references(%Dosage{} = dosage, %Drugs{} = drug, amount) do
  #   %DrugReferences{}
  #   |> DrugReferences.changeset(dosage, drug, amount)
  #   |> Repo.insert()
  # end

  def create_drug_references(dosage_id, %{"drug_id" => drug_id, "amount" => amount} = _drugref) do
    %DrugReferences{}
    |> DrugReferences.changeset(get_dosage(dosage_id), get_drug(drug_id), amount)
    |> Repo.insert()
  end

  def update_prescription(%Prescription{} = prescription, attrs) do
    prescription
    |> Prescription.changeset(attrs)
    |> Repo.update()
  end

  def update_dosage(%Dosage{} = dosage, attrs) do
    dosage
    |> Dosage.changeset(attrs)
    |> Repo.update()
  end

  defp delete_prescription(%Prescription{} = prescription) do
    Repo.delete(prescription)
  end

  def delete_prescription_by(id) do
    case prescription = get_prescription(id) do
      nil -> {:error, :not_found}
      _ -> delete_prescription(prescription)
    end
  end

  def delete_prescription_by(user_id, id) do
    with prescription when not is_nil(prescription) <- get_prescription(id),
      true <- prescription.user_id === user_id
    do
      delete_prescription(prescription)
    else
      _ -> {:error, :not_found}
    end
  end

  defp delete_dosage(%Dosage{} = dosage) do
    Repo.delete(dosage)
  end

  def delete_dosage_by(id) do
    case dosage = get_dosage(id) do
      nil -> {:error, :not_found}
      _ -> delete_dosage(dosage)
    end
  end

  def delete_dosage_by(prescription_id, id) do
    with dosage when not is_nil(dosage) <- get_dosage(id),
      true <- dosage.prescription_id === prescription_id
    do
      delete_dosage(dosage)
    else
      _ -> {:error, :not_found}
    end
  end
end
