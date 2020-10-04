defmodule HippoAbs.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :token, :string, size: 64
      add :farm_id, references(:farms, on_delete: :delete_all)

      timestamps(type: :timestamptz)
    end

    create index(:tokens, [:farm_id])

    create unique_index(:tokens, [:farm_id, :token])
  end
end
