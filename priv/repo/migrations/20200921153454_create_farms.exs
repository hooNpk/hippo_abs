defmodule HippoAbs.Repo.Migrations.CreateFarms do
  use Ecto.Migration

  def change do
    create table(:farms) do
      add :name, :string
      add :ip, :string

      timestamps(type: :timestamptz)
    end

    create unique_index(:farms, [:ip, :name])

  end
end
