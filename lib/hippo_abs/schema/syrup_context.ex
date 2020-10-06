defmodule HippoAbs.SyrupContext do
  @moduledoc """
  The Service context.
  """

  import Ecto.Query, warn: false
  alias HippoAbs.Repo

  alias HippoAbs.Service.Syrup.{Prescription, Pills}
  alias HippoAbs.Account

  require Logger


  def list_prescriptions, do: Repo.all(Prescription) |> Repo.preload(:pills)

  def list_prescriptions(%Account.User{} = user), do: get_prescriptions_by_user(user)

  def list_pills do
    Pills
    |> Repo.all()
    |> Repo.preload(:prescription)
  end

  def list_pills(prescription) do
    Ecto.assoc(prescription, :pills)
    |> Repo.all()
  end


  def get_prescription(id), do: Repo.get(Prescription, id) |> Repo.preload(:pills)

  def get_prescriptions_by_user(user) do
    Ecto.assoc(user, :prescription)
    |> Repo.all()
    |> Repo.preload(:pills)
    # |> Repo.preload(:user)
    # |> Repo.preload(:doctor)
  end

  def get_pill(id), do: Repo.get(Pills, id)

  def get_pills_by_prescription(prescription) do
    Ecto.assoc(prescription, :pills)
    |> Repo.all()
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

  def create_pill(prescription, attrs) do
    %Pills{}
    |> Pills.changeset(prescription, attrs)
    |> Repo.insert(on_conflict: :nothing)
  end

  def change_pill(prescription, attrs) do
    %Pills{}
    |> Pills.changeset(prescription, attrs)
  end

  def create_pills(prescription, pills) when is_list(pills) do
    Enum.each(pills, fn pill ->
      create_pill(prescription, pill)
    end)
  end

  def create_pills_multi(prescription, pills_attrs) do
    pills_attrs
    |> Stream.map(fn pill ->
      change_pill(prescription, pill)
    end)
    |> Stream.map(fn pill_changeset ->
      key = "pill:#{pill_changeset.changes.name}"
      Ecto.Multi.insert(Ecto.Multi.new(), key, pill_changeset)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> Repo.transaction()
    |> case do
      {:ok, _pill} -> :ok
      {:error, _key, changeset, _errors} -> {:error, changeset}
    end
  end

  def create_prescription_and_pills(user, doctor, prescription_attrs, pills_attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:insert_prescription, changes_prescription(user, doctor, prescription_attrs))
    |> Ecto.Multi.run(:insert_pills, fn _repo, %{insert_prescription: prescription} ->
      pills_attrs
      |> Stream.map(fn pill ->
        change_pill(prescription, pill)
      end)
      |> Stream.map(fn pill_changeset ->
        key = "pill:#{pill_changeset.changes.name}"
        Ecto.Multi.insert(Ecto.Multi.new(), key, pill_changeset)
      end)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> Repo.transaction()
      |> case do
        {:ok, _pill} -> {:ok, prescription}
        {:error, _key, changeset, _errors} -> {:error, changeset}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, prescription} -> {:ok, prescription.insert_prescription}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def update_prescription(%Prescription{} = prescription, attrs) do
    prescription
    |> Prescription.changeset(attrs)
    |> Repo.update()
  end

  def update_pill(%Pills{} = pill, attrs) do
    pill
    |> Pills.changeset(attrs)
    |> Repo.update()
  end

  def delete_prescription(%Prescription{} = prescription) do
    Repo.delete(prescription)
  end

  def delete_prescription(id) when is_integer(id) do
    Repo.delete(get_prescription(id))
  end

  def delete_pill(%Pills{} = pill) do
    Repo.delete(pill)
  end

  def delete_pill(id) when is_integer(id) do
    Repo.delete(get_pill(id))
  end

end
