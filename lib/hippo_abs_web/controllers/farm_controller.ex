defmodule HippoAbsWeb.FarmController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.ServiceContext

  action_fallback HippoAbsWeb.FallbackController

  def index(conn, _params) do
    conn
    |> json(ServiceContext.list_farms())
  end


  def create(conn, %{"farm" => farm_params}) do
    with  {:ok, farm} <- ServiceContext.create_farm(farm_params) do
      conn
      |> render("show.json", %{data: %{farm_id: farm.id}})
    end
  end


  def delete(conn, %{"farm" => %{"id" => id}}) do
    with  {:ok, farm} <- ServiceContext.delete_farm(id) do
      conn
      |> render("show.json", farm: farm)
    end
  end
end
