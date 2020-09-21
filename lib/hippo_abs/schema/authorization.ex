defmodule HippoAbs.Authorization do
  import Ecto.Query, warn: false

  alias HippoAbs.Repo
  alias HippoAbs.Account
  alias HippoAbs.Account.AuthToken

  @seed "hippo user token"
  @secret "9f787b792c4f4dd686cf39147d230bed"
  # @max_age 86400  # one day
  @max_age 60 # one minute for test

  # good way to generate:
  # :crypto.strong_rand_bytes(30)
  # |> Base.url_encode64
  # |> binary_part(0, 30)
  defp generate_token(id) do
    Phoenix.Token.sign(@secret, @seed, id, max_age: @max_age)
  end

  defp verify_token(token) do
    case Phoenix.Token.verify(@secret, @seed, token, max_age: @max_age) do
      {:ok, _id} -> {:ok, token}
      error -> error
    end
  end

  def authenticate_by_email_and_password(email, password) do
    user = Account.get_user_by_email(email)

    cond do
      user && Pbkdf2.verify_pass(password, user.password_hash) ->
        auth =
          Ecto.build_assoc(user, :auth_tokens, %{token: generate_token((user))})
          |> Repo.insert!()
        {:ok, auth.token}
      user ->
        {:error, :unauthorized}
      true ->
        {:error, :not_found}
    end
  end

  def authenticate_out(conn) do
    case get_auth_token(conn) do
      {:ok, token} ->
        case Repo.get_by(AuthToken, %{token: token}) do
          nil -> {:error, :not_found}
          auth_token -> Repo.delete(auth_token)
        end
      error -> error
    end
  end

  defp update_token(%AuthToken{} = auth_token, attrs) do
    auth_token
    |> AuthToken.changeset_update(attrs)
    |> Repo.update()
  end

  def revoke_authentication(conn) do
    case get_auth_token(conn) do
      {:ok, token} ->
        case Repo.get_by(AuthToken, %{token: token}) do
          nil -> {:error, :not_found}
          auth_token ->
            update_token(auth_token, %{"revoked" => true, "revoked_at" => DateTime.utc_now()})
        end
      error -> error
    end
  end

  def get_auth_token(conn) do
    case extract_token(conn) do
      {:ok, token} -> verify_token(token)
      error -> error
    end
  end

  defp extract_token(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [auth_header] -> get_token_from_header(auth_header)
       _ -> {:error, :missing_auth_header}
    end
  end

  defp get_token_from_header(auth_header) do
    {:ok, reg} = Regex.compile("Bearer\:?\s+(.*)$", "i")
    case Regex.run(reg, auth_header) do
      [_, match] -> {:ok, String.trim(match)}
      _ -> {:error, "token not found"}
    end
  end
end
