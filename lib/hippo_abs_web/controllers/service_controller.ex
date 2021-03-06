defmodule HippoAbsWeb.ServiceController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.{ServiceContext}

  action_fallback HippoAbsWeb.FallbackController


  def index(conn, %{"device_id" => device_id}, current_user) do
    with user when not is_nil(user) <- current_user,
      device when not is_nil(device) <- ServiceContext.get_device(device_id),
      services when services != [] <- ServiceContext.list_services(device)
    do
      conn
      |> render("index.json" ,%{data: %{services: services}})
    end
  end


  def index(conn, _params, current_user) do
    with user when not is_nil(user) <- current_user,
      devices when devices != [] <- ServiceContext.list_devices_by_user(user),
      services when services != [] <- ServiceContext.list_services(devices)
    do
      conn
      |> render("index.json" ,%{data: %{services: services}})
    end
  end


  def create(conn, %{"service" => %{"device_id" => did, "farm_id" => fid, "service_type_cd" => service_type_cd}}, current_user) do
    with user when not is_nil(user) <- current_user,
      {:ok, service} <- ServiceContext.create_service(did, fid, service_type_cd)
    do
      conn
      |> render("show.json", %{data: %{service_subscribe_id: service.id}})
    end
  end


  def delete(conn, %{"id" => id}, current_user) do
    with user when not is_nil(user) <- current_user,
      devices when devices != [] <- ServiceContext.list_devices(user),
      device_ids when device_ids != [] <- Enum.map(devices, &(&1.id)),
      {:ok, service} <- ServiceContext.delete_service_by(device_ids, id)
    do
      conn
      |> render("show.json", service: service)
    end
  end


  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
end
