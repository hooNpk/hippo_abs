defmodule HippoAbs.ServiceContext do
  @moduledoc """
  The Service context.
  """

  import Ecto.Query, warn: false
  alias HippoAbs.Repo

  alias HippoAbs.Service.{Device, Farm, Service}
  alias HippoAbs.Account


  def list_devices, do: Repo.all(Device) |> Repo.preload(:user)

  def list_farms, do: Repo.all(Farm)

  def list_services, do: Repo.all(Service) |> Repo.preload(:device) |> Repo.preload(:farm)

  def get_device!(id), do: Repo.get!(Device, id) |> Repo.preload(:user)

  def get_farm!(id), do: Repo.get!(Farm, id)

  def get_service!(keyword) do
    Repo.get_by!(Service, keyword)
    |> Repo.preload(:device)
    |> Repo.preload(:farm)
  end

  def create_device(%Account.User{} = user, attrs \\ %{}) do
    %Device{}
    |> Device.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def create_farm(attrs \\ %{}) do
    %Farm{}
    |> Farm.changeset(attrs)
    |> Repo.insert()
  end

  def create_service(device_id, farm_id) do
    %Service{}
    |> Service.changeset(get_device!(device_id), get_farm!(farm_id))
    |> Repo.insert(on_delete: :nothing)
  end

  def update_device(%Device{} = device, attrs) do
    device
    |> Device.changeset(attrs)
    |> Repo.update()
  end

  def update_service(%Service{} = service, [device_id: did, farm_id: fid]) do
    service
    |> Service.changeset(did, fid)
    |> Repo.update()
  end

  def delete_device(%Device{} = device) do
    Repo.delete(device)
  end

  def delete_device(id) when is_integer(id) do
    Repo.delete(get_device!(id))
  end

  def delete_farm(%Farm{} = farm) do
    Repo.delete(farm)
  end

  def delete_farm(id) when is_integer(id) do
    Repo.delete(get_farm!(id))
  end

  def delete_service(%Service{} = service) do
    Repo.delete(service)
  end

  def delete_service(keyword) when is_list(keyword) do
    Repo.delete(get_service!(keyword))
  end

  def change_device(%Device{} = device, attrs \\ %{}) do
    Device.changeset(device, attrs)
  end

  def change_farm(%Farm{} = farm, attrs \\ %{}) do
    Farm.changeset(farm, attrs)
  end
end
