defmodule HippoAbsWeb.UserController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.Account

  def index(conn, _params) do
    conn
    |> json(Account.list_users())
  end


  def create(conn, %{"user" => user_params}, _current_user) do
    conn
    |> Pow.Plug.create_user(user_params)
    |> case do
      {:ok, user, conn} ->
        conn
        |> render("show.json", %{data: %{user: user, access_token: conn.private[:api_access_token], renewal_token: conn.private[:api_renewal_token]}})

      {:error, changeset, conn} ->
        conn
        |> put_view(HippoAbsWeb.ErrorView)
        |> put_status(500)
        |> render("error.json", changeset: changeset)
    end
  end

  def delete(conn, _params, _current_user) do
    conn
    |> Pow.Plug.delete_user()
    |> case do
      {:ok, user, conn} ->
        conn
        |> render("show.json", user: user)

      {:error, user, conn} ->
        conn
        |> put_view(HippoAbsWeb.ErrorView)
        |> put_status(500)
        |> render("error.json", user: user)
    end
  end


  def show(conn, _params, current_user) do
    conn |> render("show.json", %{user: current_user})
  end


  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

end
