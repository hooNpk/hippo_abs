defmodule HippoAbs.Service.Syrup.Dosage do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder, only: [
      :id, :name, :period, :count, :amount, :detail, :prescription_id, :inserted_at, :updated_at
    ]
  }

  schema "dosage" do
    field :amount, :integer
    field :count, :integer
    field :detail, :integer
    field :name, :string
    field :period, :integer
    belongs_to :prescription, HippoAbs.Service.Syrup.Prescription
    has_many :drug_references, HippoAbs.Service.Syrup.DrugReferences

    timestamps([type: :utc_datetime_usec])
  end

  @doc false
  def changeset(dosage, attrs) do
    dosage
    |> cast(attrs, [:period, :detail, :count, :name, :amount])
    |> validate_required([:period, :detail, :count, :name, :amount])
  end

  def changeset(dosage, prescription, attrs) do
    dosage
    |> changeset(attrs)
    |> put_assoc(:prescription, prescription)
  end
end
