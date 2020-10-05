defmodule HippoAbs.Repo.Migrations.CreatePills do
  use Ecto.Migration

  def change do
    create table(:pills) do
      add :period, :smallint
      add :detail, :smallint
      add :count, :smallint
      add :name, :string
      add :amout, :smallint
      add :prescription_id, references(:prescriptions, on_delete: :delete_all)

      timestamps(type: :timestamptz)
    end

  end
end
