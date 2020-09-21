defmodule HippoAbsWeb.Plugs.Authenticate do
  import Plug.Conn

  alias HippoAbs.Repo
  alias HippoAbs.Account.AuthToken
  alias HippoAbs.Authorization


  def init(opt), do: opt

  def call(conn, _param) do
    case Authorization.get_auth_token(conn) do
      {:ok, token} ->
        case Repo.get_by(AuthToken, [token: token, revoked: false]) |> Repo.preload(:user) do
          nil -> unauthorized(conn)
          auth_token -> authorized(conn, auth_token.user)
        end
      _ -> unauthorized(conn)
    end
  end

  defp authorized(conn, user) do
    # If you want, add new values to `conn`
    conn
    |> assign(:signed_in, true)
    |> assign(:signed_user, user)
  end

  defp unauthorized(conn) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt()
  end
end
