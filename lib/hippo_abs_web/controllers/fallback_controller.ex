defmodule HippoAbsWeb.FallbackController do
  use Phoenix.Controller

  require Logger

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

  def call(conn, :not_authenticated) do
    conn
    |> put_status(401)
    |> json(%{error: %{code: 401, message: "Not authenticated"}})
  end

  def call(conn, []) do
    conn
    |> put_status(401)
    |> json(%{error: %{code: 404, message: "list is empty"}})
  end

  def call(conn, nil) do
    conn
    |> put_status(401)
    |> json(%{error: %{code: 404, message: "result is empty"}})
  end

  def call(conn, _msg) do
    # IO.inspect(Process.info(self(), :current_stacktrace), label: "STACKTRACE")
    conn
    |> put_status(500)
    |> put_view(HippoAbsWeb.ErrorView)
    |> render("error.json", error: "unknown_error")
  end
end
