defmodule HippoAbs.Repo.Migrations.CreateDrugs do
  use Ecto.Migration

  def change do
    create table(:drugs) do
      add :manufacturer, :string
      # add :product_id, :integer
      add :permission_date, :date
      add :con_product_nm_kr, :string
      add :classification_nm, :string
      add :classification_cd, :integer
      add :distributor, :string
      add :con_substance_nm_kr, :string
      add :con_substance_nm_en, :string
      add :classification, :string
      add :contraindications, :string
      add :compound, :string
      add :substance_nm_en, :string
      add :substance_nm_kr, :string
      add :appearance, :text
      add :effect_classification, :string
      add :item_nm, :string, size: 1024
      add :prescription, :string
      add :con_product_id, :integer
      add :con_appearance, :text

      timestamps([type: :timestamptz])
    end

    create index(:drugs, [:con_product_nm_kr])
    create index(:drugs, [:con_substance_nm_kr])
    create index(:drugs, [:item_nm])

  end
end
