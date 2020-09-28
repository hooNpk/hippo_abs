defmodule HippoAbsWeb.ServiceView do
  use HippoAbsWeb, :view

  require Logger

  def render("show.json", %{data: %{service_id: service_id}}) do
    Logger.debug("service added successfully #{service_id}")
    %{data: %{service_id: service_id}}
  end

  # TODO
  def render("show.json", %{service: service}) do
    Logger.debug("service added successfully #{inspect service}")
    %{data: %{service: service}}
  end

  def render("index.json", %{data: %{services: services}}) do
    Logger.debug("services added successfully #{inspect services}")
    %{data: %{services: services}}
  end
end
