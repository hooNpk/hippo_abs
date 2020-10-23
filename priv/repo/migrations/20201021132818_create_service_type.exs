defmodule HippoAbs.Repo.Migrations.CreateServiceType do
  use Ecto.Migration

  import Ecto.Query

  def change do
    create table(:service_type) do
      add :service_type_cd, :smallint, null: false
      add :service_name, :string
      add :description, :text

      timestamps([type: :timestamptz])
    end

    create unique_index(:service_type, [:service_type_cd])

    flush()

    HippoAbs.Repo.insert_all("service_type", [
      %{service_type_cd: 1, service_name: "Syrup Service", description: "투약 알람 서비스", inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
      %{service_type_cd: 2, service_name: "DIB Service", description: "당뇨발 서비스", inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
      %{service_type_cd: 100, service_name: "DIB Service (임상)", description: "당뇨발 서비스 1차 임상", inserted_at: DateTime.utc_now(), updated_at: DateTime.utc_now()},
    ])
  end
end
