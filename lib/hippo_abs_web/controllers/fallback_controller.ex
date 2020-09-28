defmodule HippoAbsWeb.FallbackController do
  use Phoenix.Controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(HippoAbsWeb.ErrorView)
    |> render("error.json", error: "not found")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(403)
    |> put_view(HippoAbsWeb.ErrorView)
    |> render("error.json", error: "not authorized")
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(500)
    |> put_view(HippoAbsWeb.ErrorView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, _) do
    conn
    |> put_status(500)
    |> put_view(HippoAbsWeb.ErrorView)
    |> render("error.json", error: "unknown_error")
  end
end
