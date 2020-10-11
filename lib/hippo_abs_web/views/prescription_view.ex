defmodule HippoAbsWeb.PrescriptionView do
  use HippoAbsWeb, :view

  require Logger

  def render("show.json", %{data: %{prescription_id: prescription_id}}) do
    Logger.debug("prescription successfully #{prescription_id}")
    %{data: %{prescription_id: prescription_id}}
  end

  def render("show.json", %{data: %{drug: drug}}) do
    Logger.debug("drug  successfully #{drug.item_nm}")
    %{data: %{drug: drug}}
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

  def render("index.json", %{data: %{drugs: drugs}}) do
    Logger.debug("search drugs successfully #{inspect drugs}")
    %{data: %{drugs: drugs}}
  end
end
