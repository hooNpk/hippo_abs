defmodule HippoAbs.Service.Syrup.Drugs do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder, only: [
      :id,
      :appearance,
      :classification,
      :classification_cd,
      :classification_nm,
      :compound,
      :con_appearance,
      :con_product_id,
      :con_product_nm_kr,
      :con_substance_nm_en,
      :con_substance_nm_kr,
      :contraindications,
      :distributor,
      :effect_classification,
      :item_nm,
      :manufacturer,
      :permission_date,
      :prescription,
      :substance_nm_en,
      :substance_nm_kr
    ]
  }

  schema "drugs" do
    field :appearance, :string
    field :classification, :string
    field :classification_cd, :integer
    field :classification_nm, :string
    field :compound, :string
    field :con_appearance, :string
    field :con_product_id, :integer
    field :con_product_nm_kr, :string
    field :con_substance_nm_en, :string
    field :con_substance_nm_kr, :string
    field :contraindications, :string
    field :distributor, :string
    field :effect_classification, :string
    field :item_nm, :string
    field :manufacturer, :string
    field :permission_date, :date
    field :prescription, :string
    # field :product_id, :integer
    field :substance_nm_en, :string
    field :substance_nm_kr, :string

    timestamps()
  end

  @doc false
  def changeset(drugs, attrs) do
    drugs
    |> cast(attrs, [:manufacturer, :product_id, :permission_date, :con_product_nm_kr, :classification_nm, :classification_cd, :distributor, :con_substance_nm_kr, :con_substance_nm_en, :classification, :contraindications, :compound, :substance_nm_en, :substance_nm_kr, :appearance, :effect_classification, :item_nm, :prescription, :con_product_id, :con_appearance])
    |> validate_required([:manufacturer, :product_id, :permission_date, :con_product_nm_kr, :classification_nm, :classification_cd, :distributor, :con_substance_nm_kr, :con_substance_nm_en, :classification, :contraindications, :compound, :substance_nm_en, :substance_nm_kr, :appearance, :effect_classification, :item_nm, :prescription, :con_product_id, :con_appearance])
  end
end
