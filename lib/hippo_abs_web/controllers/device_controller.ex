defmodule HippoAbsWeb.FarmController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.ServiceContext

  def index(conn, _params) do
    conn
    |> json(ServiceContext.list_farms())
  end


  def create(conn, %{"device" => device_params}) do
    case ServiceContext.create_device(device_params) do
      {:ok, device} ->
        conn
        |> render("show.json", %{data: %{device_id: device.id}})

      {:error, changeset} ->
        conn
        |> put_view(HippoAbsWeb.ErrorView)
        |> put_status(500)
        |> render("error.json", changeset: changeset)
    end
  end


  def delete(conn, %{"device" => %{"id" => id}}) do
    case ServiceContext.delete_device(id) do
      {:ok, device} ->
        conn
        |> render("show.json", device: device)
      {:error, device} ->
        conn
        |> put_view(HippoAbsWeb.ErrorView)
        |> put_status(500)
        |> render("error.json", device: device)
    end
  end

end
