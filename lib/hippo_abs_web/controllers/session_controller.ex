defmodule HippoAbsWeb.SessionController do
  use HippoAbsWeb, :controller

  require Logger

  alias HippoAbsWeb.Plugs.Authorization


  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.authenticate_user(user_params)
    |> case do
      {:ok, conn} ->
        conn
        |> put_status(200)
        |> render("show.json", %{data: %{access_token: conn.private[:api_access_token], renewal_token: conn.private[:api_renewal_token]}})

      {:error, conn} ->
        conn
        |> put_view(HippoAbsWeb.ErrorView)
        |> put_status(500)
        |> render("error.json", error: %{status: 401, message: "Invalid email or password"})
    end
  end

  def renew(conn, _params) do
    config = Pow.Plug.fetch_config(conn)

    conn
    |> Authorization.renew(config)
    |> case do
      {conn, nil} ->
        conn
        |> put_status(401)
        |> put_view(HippoAbsWeb.ErrorView)
        |> render("error.json", error: %{status: 401, message: "Invalid token"})

      {conn, _user} ->
        json(conn, %{data: %{access_token: conn.private[:api_access_token], renewal_token: conn.private[:api_renewal_token]}})
    end
  end

  def delete(conn, _params) do
    conn
    |> Pow.Plug.delete()
    |> json(%{data: %{msg: "log-out success."}})
  end
end
