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
              true ->
                Logger.info("allow")
                conn |> send_resp(200, "allow")
              _ ->
                Logger.error("deny")
                conn |> send_resp(200, "deny")
            end
    else
      _ ->
        Logger.error("deny")
        conn |> send_resp(200, "deny")
    end
  end

  def auth_topic(conn, %{"username" => uid, "routing_key" => routing_key}) do
    with  user when not is_nil(user) <- Account.get_user_by_uid(uid),
          devices when devices != [] <- ServiceContext.list_devices(user),
          services when services != [] <- ServiceContext.list_services(devices) do
            Enum.any?(services, fn service ->
              topic = uid <> "|" <> "dtx" <> "|" <> Integer.to_string(service.id) <> "|" <> Integer.to_string(service.service_type_cd)
              Enum.member?(["UP." <> topic, "DN." <> topic], routing_key)
            end)
            |> case do
              true ->
                Logger.info("allow")
                conn |> send_resp(200, "allow")
              _ ->
                Logger.error("deny")
                conn |> send_resp(200, "deny")
            end
    else
      _ ->
        Logger.error("deny")
        conn |> send_resp(200, "deny")
    end
  end


  def auth_vhost(conn, %{"vhost" => "/"}), do: conn |> send_resp(200, "allow")
  def auth_vhost(conn, %{"vhost" => _}), do: conn |> send_resp(200, "deny")


  def auth_resource(conn, %{"vhost" => "/", "resource" => resource}) when resource in ["exchange", "queue", "topic"], do: conn |> send_resp(200, "allow")
  def auth_resource(conn, %{"vhost" => _}), do: conn |> send_resp(200, "deny")
end
