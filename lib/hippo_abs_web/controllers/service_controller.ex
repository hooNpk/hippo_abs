defmodule HippoAbsWeb.ServiceController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.ServiceContext

  def index(conn, _params) do
    conn
    |> json(ServiceContext.list_services())
  end


  def create(conn, %{"service" => %{"device_id" => did, "farm_id" => fid}}) do
    case ServiceContext.create_service(did, fid) do
      {:ok, service} ->
        conn
        |> render("show.json", %{data: %{service_id: service.id}})

      {:error, changeset} ->
        conn
        |> put_view(HippoAbsWeb.ErrorView)
        |> put_status(500)
        |> render("error.json", changeset: changeset)
    end
  end


  def delete(conn, %{"service" => %{"id" => id}}) do
    case ServiceContext.delete_service(id) do
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
