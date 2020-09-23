defmodule HippoAbs.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :farm_id, references(:farms, on_delete: :delete_all)
      add :device_id, references(:devices, on_delete: :delete_all)

      timestamps(type: :timestamptz)
    end

    create index(:services, [:farm_id])
    create index(:services, [:device_id])

    create unique_index(:services, [:farm_id, :device_id])
  end
end
