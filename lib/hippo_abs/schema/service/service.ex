defmodule HippoAbs.Service.Service do
  use Ecto.Schema
  import Ecto.Changeset

  schema "services" do
    belongs_to :device, HippoAbs.Service.Device
    belongs_to :farm, HippoAbs.Service.Farm

    timestamps([type: :utc_datetime_usec])
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [])
    |> validate_required([])
    |> unique_constraint([:device_id, :farm_id], name: :services_farm_id_device_id_index)
  end

  def changeset(service, device, farm) do
    service
    |> changeset(%{})
    |> put_assoc(:device, device)
    |> put_assoc(:farm, farm)
  end
end
