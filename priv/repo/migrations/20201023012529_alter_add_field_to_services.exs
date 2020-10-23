defmodule HippoAbs.Repo.Migrations.AlterAddFieldToServices do
  use Ecto.Migration

  def change do
    alter table(:services) do
      add :service_type_cd, :smallint, null: false, default: 0
    end
  end
end
