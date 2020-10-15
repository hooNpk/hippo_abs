defmodule HippoAbsWeb.DosageView do
  use HippoAbsWeb, :view

  require Logger


  def render("show.json", %{data: %{dosage: dosage}}) do
    Logger.debug("search drugs successfully #{inspect dosage}")
    %{data: %{dosage: dosage}}
  end

  def render("index.json", %{data: %{dosage: dosage}}) do
    Logger.debug("dosage added successfully #{inspect dosage}")
    %{data: %{dosage: dosage}}
  end
end
