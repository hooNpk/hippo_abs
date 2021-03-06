defmodule HippoAbsWeb.PrescriptionView do
  use HippoAbsWeb, :view

  require Logger

  def render("show.json", %{data: %{prescription_id: prescription_id}}) do
    Logger.debug("prescription successfully #{prescription_id}")
    %{data: %{prescription_id: prescription_id}}
  end

  def render("show.json", %{data: %{prescription: prescription}}) do
    Logger.debug("prescription added successfully #{inspect prescription}")
    %{data: %{prescription: prescription}}
  end

  def render("index.json", %{data: %{prescriptions: prescriptions}}) do
    Logger.debug("prescriptions added successfully #{inspect prescriptions}")
    %{data: %{prescriptions: prescriptions}}
  end

  def render("show.json", %{data: %{dosage: dosage}}) do
    Logger.debug("search drugs successfully #{inspect dosage}")
    %{data: %{dosage: dosage}}
  end

  def render("index.json", %{data: %{dosage: dosage}}) do
    Logger.debug("dosage added successfully #{inspect dosage}")
    %{data: %{dosage: dosage}}
  end
end
