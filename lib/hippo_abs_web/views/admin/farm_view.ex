defmodule HippoAbsWeb.Admin.FarmView do
  use HippoAbsWeb, :view

  require Logger

  def render("show.json", %{data: %{farm_id: farm_id}}) do
    Logger.debug("farm successfully #{farm_id}")
    %{data: %{farm_id: farm_id}}
  end

  # TODO
  def render("show.json", %{farm: farm}) do
    Logger.debug("farm added successfully #{farm.name}")
    %{data: %{farm: farm}}
  end

  def render("index.json", %{data: %{farms: farms}}) do
    Logger.debug("farm added successfully #{inspect farms}")
    %{data: %{farms: farms}}
  end
end
