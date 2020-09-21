defmodule HippoAbsWeb.SessionView do
  use HippoAbsWeb, :view

  require Logger

  def render("show.json", %{data: %{access_token: access_token, renewal_token: renewal_token}}) do
    %{data: %{access_token: access_token, renewal_token: renewal_token}}
  end

end
