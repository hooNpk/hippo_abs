defmodule HippoAbs.Service.Syrup.DrugReferences do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder, only: [
      :id, :drug_id, :dosage_id, :amount, :inserted_at, :updated_at
    ]
  }

  schema "drug_references" do
    belongs_to :drug, HippoAbs.Service.Syrup.Drugs
    belongs_to :dosage, HippoAbs.Service.Syrup.Dosage
    field :amount, :integer

    timestamps([type: :utc_datetime_usec])
  end

  @doc false
  def changeset(drugref, attrs) do
    drugref
    |> cast(attrs, [:drug_id, :dosage_id, :amount])
    |> validate_required([:drug_id, :dosage_id, :amount])
    |> unique_constraint([:drug_id, :dosage_id], name: :drug_references_drug_id_dosage_id_index)
  end

  def changeset(drugref, dosage, drug, amount) do
    drugref
    |> changeset(%{dosage_id: dosage.id, drug_id: drug.id, amount: amount})
    |> put_assoc(:dosage, dosage)
    |> put_assoc(:drug, drug)
  end
end
