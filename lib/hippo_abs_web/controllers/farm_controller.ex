defmodule HippoAbsWeb.DeviceController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.ServiceContext

  def index(conn, _params) do
    conn
    |> json(ServiceContext.list_devices())
  end


  def create(conn, %{"farm" => farm_params}) do
    case ServiceContext.create_farm(farm_params) do
      {:ok, farm} ->
        conn
        |> render("show.json", %{data: %{farm_id: farm.id}})

      {:error, changeset} ->
        conn
        |> put_view(HippoAbsWeb.ErrorView)
        |> put_status(500)
        |> render("error.json", changeset: changeset)
    end
  end


  def delete(conn, %{"farm" => %{"id" => id}}) do
    case ServiceContext.delete_farm(id) do
      {:ok, farm} ->
        conn
        |> render("show.json", farm: farm)
      {:error, farm} ->
        conn
        |> put_view(HippoAbsWeb.ErrorView)
        |> put_status(500)
        |> render("error.json", farm: farm)
    end
  end

end
