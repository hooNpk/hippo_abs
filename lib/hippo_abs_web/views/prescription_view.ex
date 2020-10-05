defmodule HippoAbsWeb.PrescriptionView do
  use HippoAbsWeb, :view

  require Logger

  def render("show.json", %{data: %{prescription_id: prescription_id}}) do
    Logger.debug("prescription successfully #{prescription_id}")
    %{data: %{prescription_id: prescription_id}}
  end

  # TODO
  def render("show.json", %{prescription: prescription}) do
    Logger.debug("prescription added successfully #{prescription.id}")
    %{data: %{prescription: prescription}}
  end

  def render("index.json", %{data: %{prescriptions: prescriptions}}) do
    Logger.debug("prescriptions added successfully #{inspect prescriptions}")
    %{data: %{prescriptions: prescriptions}}
  end
end
