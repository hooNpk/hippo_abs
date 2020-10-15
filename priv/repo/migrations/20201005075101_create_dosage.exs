defmodule HippoAbs.Repo.Migrations.CreateDosage do
  use Ecto.Migration

  def change do
    create table(:dosage) do
      add :period, :smallint
      add :detail, :smallint
      add :count, :smallint
      add :name, :string
      add :amount, :smallint
      add :prescription_id, references(:prescriptions, on_delete: :delete_all)

      timestamps(type: :timestamptz)
    end

  end
end
