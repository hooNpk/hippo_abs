defmodule HippoAbsWeb.Plugs.RoleAuthorization do
  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, opts) do
    # Logger.warn(inspect opts)
    # Logger.warn(inspect conn.assigns.current_user |> Map.fetch(:type))
    with  {:ok, value} <- conn.assigns.current_user |> Map.fetch(:type),
          true <- Keyword.get(opts, :type) |> Enum.find_value(&(&1 == value)) do
            conn
    else
      :error -> error_handle(conn, "user type not found")
      false -> error_handle(conn, "Not authorized (invalid role)")
    end
  end

  defp error_handle(conn, message) do
    conn
    |> put_status(500)
    |> Phoenix.Controller.put_view(HippoAbsWeb.ErrorView)
    |> Phoenix.Controller.render("error.json", %{error: message})
    # |> Phoenix.Controller.render("500.html", %{error: message})
    |> halt()
  end
end
