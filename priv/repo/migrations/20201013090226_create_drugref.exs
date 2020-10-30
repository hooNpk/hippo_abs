defmodule HippoAbs.Repo.Migrations.CreateDrugReferences do
  use Ecto.Migration

  def change do
    create table(:drug_references) do
      add :drug_id, references(:drugs, on_delete: :delete_all)
      add :dosage_id, references(:dosage, on_delete: :delete_all)
      add :amount, :smallint

      timestamps(type: :timestamptz)
    end

    create index(:drug_references, [:drug_id])
    create index(:drug_references, [:dosage_id])

    create unique_index(:drug_references, [:drug_id, :dosage_id])
  end
end
