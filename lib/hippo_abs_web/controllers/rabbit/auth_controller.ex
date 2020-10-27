defmodule HippoAbsWeb.Rabbit.AuthController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.Account
  alias HippoAbs.ServiceContext
  alias Pow.Ecto.Schema.Password

  # action_fallback HippoAbsWeb.FallbackController


  def auth_user(conn, %{"username" => uid, "password" => password}) do
    with  user when not is_nil(user) <- Account.get_user_by_uid(uid),
          verified when is_boolean(verified) <- Password.pbkdf2_verify(password, user.password_hash) do
            case verified do
              true -> conn |> put_status(:created) |> json("allow")
              _ -> conn |> json("deny")
            end
    else
      _ -> conn |> json("deny")
    end
  end

  def auth_topic(conn, %{"username" => uid, "routing_key" => routing_key}) do
    with  user when not is_nil(user) <- Account.get_user_by_uid(uid),
          devices when devices != [] <- ServiceContext.list_devices(user),
          services when services != [] <- ServiceContext.list_services(devices) do
          # farms <- ServiceContext.list_farms(devices) do
          # topics <- ServiceContext.list_tokens(farms) do
            Enum.any?(services, fn service ->
              # farm_name = String.replace(service.name, [" ", ".", ",", "/", "|"], "")
              Enum.member?([
                "UP/" <> uid <> "|" <> service.id <> "|" <> service.service_type_cd,
                "DN/" <> uid <> "|" <> service.id <> "|" <> service.service_type_cd,
              ], routing_key)
            end)
            |> case do
              true -> conn |> put_status(:created) |> json("allow")
              _ -> conn |> json("deny")
            end
    else
      _ -> conn |> json("deny")
    end
  end


  def auth_vhost(conn, %{"vhost" => "/"}), do: conn |> put_status(:created) |> json("allow")
  def auth_vhost(conn, %{"vhost" => _}), do: conn |> json("deny")


  def auth_resource(conn, %{"vhost" => "/", "resource" => resource}) when resource in ["exchange", "queue", "topic"], do: conn |> put_status(:created) |> json("allow")
  def auth_resource(conn, %{"vhost" => _}), do: conn |> json("deny")
end
