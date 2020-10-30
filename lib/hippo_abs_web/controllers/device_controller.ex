defmodule HippoAbsWeb.DeviceController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.{ServiceContext}

  action_fallback HippoAbsWeb.FallbackController

  def index(conn, _param, current_user) do
    # with  user when not is_nil(user) <- Account.get_user(current_user.id),
          # {:ok, devices} <- ServiceContext.list_devices(user) do
    with user when not is_nil(user) <- current_user,
      devices when not is_nil(devices) <- ServiceContext.list_devices(user)
    do
      conn
      |> render("index.json", %{data: %{devices: devices}})
    end
  end


  def create(conn, %{"device" => device_params}, current_user) do
    with user when not is_nil(user) <- current_user,
      {:ok, device} <- ServiceContext.create_device(user, device_params)
    do
      conn
        |> render("show.json", %{data: %{id: device.id}})
    end
  end


  def delete(conn, %{"device" => %{"id" => id}}, current_user) do
    with user when not is_nil(user) <- current_user,
      {:ok, device}<- ServiceContext.delete_device(id)
    do
      conn
      |> render("show.json", device: device)
    end
  end


  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
end
