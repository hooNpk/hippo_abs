defmodule HippoAbs.Repo.Migrations.CreatePrescription do
  use Ecto.Migration

  def change do
    create table(:prescriptions) do
      add :start_date, :date
      add :end_date, :date
      add :user_id, references(:users, on_delete: :delete_all)
      add :doctor_id, references(:users, on_delete: :nothing)

      timestamps(type: :timestamptz)
    end

    create index(:prescriptions, [:user_id])
    create index(:prescriptions, [:doctor_id])
  end
end
