defmodule HippoAbsWeb.RabbitmqController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.Account
  alias HippoAbs.ServiceContext

  action_fallback HippoAbsWeb.FallbackController


  def auth_user(conn, %{"username" => email, "password" => password}) do
    with  user when not is_nil(user) <- Account.get_user_by_email(email),
          verified when is_boolean(verified) <- Pow.Ecto.Schema.Password.pbkdf2_verify(password, user.password_hash) do

            case verified do
              true -> conn |> json("allow")
              _ -> conn |> json("deny")
            end
    end
  end

  def auth_topic(conn, %{"username" => email, "routing_key" => routing_key}) do
    with  user when not is_nil(user) <- Account.get_user_by_email(email),
          devices <- ServiceContext.list_devices(user),
          tokens <- ServiceContext.list_tokens(devices) do

            Enum.any?(tokens, fn token ->
              String.contains?(String.capitalize(token.token), String.capitalize(routing_key))
            end)
            |> case do
              true -> conn |> json("allow")
              _ -> conn |> json("deny")
            end
    end
  end
end
