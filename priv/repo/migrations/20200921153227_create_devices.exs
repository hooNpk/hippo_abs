defmodule HippoAbs.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :name, :string
      add :device_id, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :timestamptz)
    end

    create unique_index(:devices, [:user_id, :device_id])
    create index(:devices, [:device_id])
  end
end
