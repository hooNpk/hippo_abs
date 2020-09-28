defmodule HippoAbsWeb.DeviceView do
  use HippoAbsWeb, :view

  require Logger

  def render("show.json", %{data: %{device_id: device_id}}) do
    Logger.debug("device added successfully #{device_id}")
    %{data: %{device_id: device_id}}
  end

  # TODO
  def render("show.json", %{user: user}) do
    Logger.debug("device added successfully #{user.name}")
    %{data: %{user: user}}
  end

  def render("index.json", %{data: %{devices: devices}}) do
    Logger.debug("device added successfully #{inspect devices}")
    %{data: %{devices: devices}}
  end
end
