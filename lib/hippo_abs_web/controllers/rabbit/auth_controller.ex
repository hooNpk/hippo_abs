defmodule HippoAbsWeb.Rabbit.AuthController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.Account
  alias HippoAbs.ServiceContext

  # action_fallback HippoAbsWeb.FallbackController


  def auth_user(conn, %{"username" => uid, "password" => password}) do
    with  user when not is_nil(user) <- Account.get_user_by_uid(uid),
          verified when is_boolean(verified) <- Pow.Ecto.Schema.Password.pbkdf2_verify(password, user.password_hash) do

      case verified do
        true -> conn |> json("allow")
        _ -> conn |> json("deny")
      end
    else
      _ -> conn |> json("deny")
    end
  end

  def auth_topic(conn, %{"username" => uid, "routing_key" => routing_key}) do
    with  user when not is_nil(user) <- Account.get_user_by_uid(uid),
          devices <- ServiceContext.list_devices(user),
          farms <- ServiceContext.list_farms(devices) do
          # topics <- ServiceContext.list_tokens(farms) do

            Enum.any?(farms, fn farm ->
              service_name = String.replace(farm.name, [" ", ".", ",", "/", "|"], "")
              Enum.member?(["UP/" <> uid <> "|" <> service_name, "DN/" <> uid <> "|" <> service_name], routing_key)
            end)
            |> case do
              true -> conn |> json("allow")
              _ -> conn |> json("deny")
            end
    else
      _ -> conn |> json("deny")
    end
  end


  def auth_vhost(conn, %{"vhost" => "/"}), do: conn |> json("apply")
  def auth_vhost(conn, %{"vhost" => _}), do: conn |> json("deny")


  def auth_resource(conn, %{"vhost" => "/", "resource" => resource}) when resource in ["exchange", "queue", "topic"], do: conn |> json("apply")
  def auth_resource(conn, %{"vhost" => _}), do: conn |> json("deny")
end
