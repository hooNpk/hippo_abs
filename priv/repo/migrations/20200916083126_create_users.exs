defmodule HippoAbs.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uid, :string, size: 64
      add :name, :string
      add :password_hash, :string
      add :type, :smallint
      add :phonenum, :string
      add :gender, :smallint
      add :birth, :date
      add :hospital_code, :smallint

      timestamps(type: :timestamptz)
    end

    create unique_index(:users, [:uid])
  end

end
