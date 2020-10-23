defmodule HippoAbs.Service.Service do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [
      :id, :device_id, :farm_id, :service_type_cd, :inserted_at, :farm, :device, :updated_at
    ]
  }

  schema "services" do
    belongs_to :device, HippoAbs.Service.Device
    belongs_to :farm, HippoAbs.Service.Farm
    field :service_type_cd, :integer

    timestamps([type: :utc_datetime_usec])
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:device_id, :farm_id, :service_type_cd])
    |> validate_required([:device_id, :farm_id, :service_type_cd])
    |> validate_number(:service_type_cd, greater_than: 0, less_than_or_equal_to: 10000)
    |> unique_constraint([:device_id, :farm_id], name: :services_farm_id_device_id_index)
  end

  def changeset(service, device, farm, service_type_cd) do
    service
    |> changeset(%{device_id: device.id, farm_id: farm.id, service_type_cd: service_type_cd})
    |> put_assoc(:device, device)
    |> put_assoc(:farm, farm)
  end
end
