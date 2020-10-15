defmodule HippoAbsWeb.Admin.ServiceController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.{ServiceContext}

  action_fallback HippoAbsWeb.FallbackController

  def index(conn, %{"device_id" => device_id}, _current_user) do
    with  device when not is_nil(device) <- ServiceContext.get_device(device_id),
          services when not is_nil(services) <- ServiceContext.list_services(device) do
            conn
            |> render("index.json" ,%{data: %{services: services}})
    end
  end


  def index(conn, params, current_user) do
    Logger.warn(inspect params)
    with  user when not is_nil(user) <- current_user,
          devices when not is_nil(devices) <- ServiceContext.get_devices_by_user(user),
          services when not is_nil(services) <- ServiceContext.list_services(devices) do
            conn
            |> render("index.json" ,%{data: %{services: services}})
    end
  end


  def create(conn, %{"service" => %{"device_id" => did, "farm_id" => fid}}, _current_user) do
    with  {:ok, service} <- ServiceContext.create_service(did, fid) do
      conn
      |> render("show.json", %{data: %{service_subscribe_id: service.id}})
    end
  end


  def delete(conn, %{"service" => %{"id" => id}}, _current_user) do
    with  {:ok, service} <- ServiceContext.delete_service(id) do
      conn
      |> render("show.json", service: service)
    end
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
end
