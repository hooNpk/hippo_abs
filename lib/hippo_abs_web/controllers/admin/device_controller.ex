defmodule HippoAbsWeb.Admin.DeviceController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.{ServiceContext}

  action_fallback HippoAbsWeb.FallbackController

  # def index(conn, _param, current_user) do
  #   with  user when not is_nil(user) <- Account.get_user(current_user.id),
  #         # {:ok, devices} <- ServiceContext.list_devices(user) do
  #         devices when not is_nil(devices) <- ServiceContext.list_devices(user) do
  #           conn
  #           |> render("index.json", %{data: %{devices: devices}})
  #   end
  # end

  def index(conn, _param) do
    with  devices when not is_nil(devices) <- ServiceContext.list_devices() do
            conn
            |> render("index.json", %{data: %{devices: devices}})
    end
  end


  def delete(conn, %{"device" => %{"id" => id}}) do
    with  {:ok, device}<- ServiceContext.delete_device(id) do
      conn
      |> render("show.json", device: device)
    end
  end

end
