defmodule HippoAbsWeb.Admin.UserView do
  use HippoAbsWeb, :view

  require Logger

  def render("show.json", %{data: %{user: user, access_token: access_token, renewal_token: renewal_token}}) do
    Logger.debug("user added successfully #{user.name}")
    %{data: %{access_token: access_token, renewal_token: renewal_token}}
  end

  def render("show.json", %{user: user}) do
    Logger.debug("user added successfully #{user.name}")
    %{data: %{user: user}}
  end
end
