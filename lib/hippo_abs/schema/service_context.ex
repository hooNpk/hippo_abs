defmodule HippoAbs.ServiceContext do
  @moduledoc """
  The Service context.
  """

  import Ecto.Query, warn: false
  alias HippoAbs.Repo

  alias HippoAbs.Service.{Device, Farm, Token, Service}
  alias HippoAbs.Account

  require Logger


  def list_devices, do: Repo.all(Device) |> Repo.preload(:user)

  def list_devices(%Account.User{} = user), do: get_devices_by_user(user)

  def list_farms do
    Farm
    |> Repo.all()
    # |> Repo.preload(:tokens)
  end

  def list_farms(device) do
    Ecto.assoc(device, :services)
    |> Repo.all()
    |> Ecto.assoc(:farm)
    |> Repo.all()
  end

  def list_tokens(%Device{} = device) do
    list_farms(device)
    |> Ecto.assoc(:tokens)
    |> Repo.all()
  end

  def list_tokens(%Farm{} = farm) do
    farm
    |> Ecto.assoc(:tokens)
    |> Repo.all()
  end


  def list_tokens, do: Repo.all(Token) |> Repo.preload(:farm)

  def list_services, do: Repo.all(Service) |> Repo.preload([:farm, :device])

  def list_services(devices) when is_list(devices) do
    Enum.reduce(devices, [], fn (element, acc) ->
      result =
        Ecto.assoc(element, :services)
        |> Repo.all()
        |> Repo.preload([:farm, :device])
      result ++ acc
    end)
  end

  def list_services(%Device{} = device) do
    Ecto.assoc(device, :services)
    |> Repo.all()
    |> Repo.preload([:farm, :device])
  end

  def get_device(id), do: Repo.get(Device, id) |> Repo.preload(:user)

  def get_devices_by_user(user) do
    # user
    # |> Repo.preload(:device)
    # |> Map.fetch(:device)
    Ecto.assoc(user, :device)
    |> Repo.all()
  end

  def get_farm(id), do: Repo.get(Farm, id)

  def get_token(id), do: Repo.get(Token, id)

  def get_tokens_by_farm(farm) do
    Ecto.assoc(farm, :tokens)
    |> Repo.all()
  end

  def get_service(keyword) do
    Repo.get_by(Service, keyword) # device_id: 1, farm_id: 1
    |> Repo.preload(:device)
    |> Repo.preload(:farm)
  end

  def get_service_detail(service_type_cd) do
    query =
      from s in "service_type",
        where: s.service_type_cd == ^service_type_cd,
        select: map(s, [:id, :service_name, :service_type_cd, :description])

    Repo.all(query)
  end

  def create_device(%Account.User{} = user, attrs \\ %{}) do
    %Device{}
    |> Device.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def create_farm(attrs) do
    %Farm{}
    |> Farm.changeset(attrs)
    |> Repo.insert()
  end

  def create_farm(attrs, tokens) do
    %Farm{}
    |> Farm.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tokens, tokens)
    |> Repo.insert()
  end

  def create_service(device_id, farm_id, service_type_cd) do
    %Service{}
    |> Service.changeset(get_device(device_id), get_farm(farm_id), service_type_cd)
    |> Repo.insert()
    # |> Repo.insert(on_conflict: :nothing)
  end

  def create_token(farm_id, token) when is_map(token) do
    %Token{}
    |> Token.changeset(token, get_farm(farm_id))
    |> Repo.insert(on_conflict: :nothing)
  end

  def create_token(farm_id, tokens) when is_list(tokens) do
    Enum.each(tokens, fn token ->
      create_token(farm_id, token)
    end)
  end

  def update_device(%Device{} = device, attrs) do
    device
    |> Device.changeset(attrs)
    |> Repo.update()
  end

  def update_service(%Service{} = service, [device_id: did, farm_id: fid, service_type_cd: service_type_cd]) do
    service
    |> Service.changeset(did, fid, service_type_cd)
    |> Repo.update()
  end

  def delete_device(%Device{} = device) do
    Repo.delete(device)
  end

  def delete_device(id) when is_integer(id) do
    Repo.delete(get_device(id))
  end

  def delete_farm(%Farm{} = farm) do
    Repo.delete(farm)
  end

  def delete_farm(id) when is_integer(id) do
    Repo.delete(get_farm(id))
  end

  def delete_service(%Service{} = service) do
    Repo.delete(service)
  end

  def delete_service(keyword) when is_list(keyword) do
    Repo.delete(get_service(keyword))
  end

  def change_device(%Device{} = device, attrs \\ %{}) do
    Device.changeset(device, attrs)
  end

  def change_farm(%Farm{} = farm, attrs \\ %{}) do
    Farm.changeset(farm, attrs)
  end
end
