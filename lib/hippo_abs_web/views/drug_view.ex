defmodule HippoAbsWeb.DrugView do
  use HippoAbsWeb, :view

  require Logger

  def render("show.json", %{data: %{drug: drug}}) do
    Logger.debug("drug  successfully #{inspect drug}")
    %{data: %{drug: drug}}
  end

  def render("index.json", %{data: %{drugs: drugs}}) do
    Logger.debug("search drugs successfully #{inspect drugs}")
    %{data: %{drugs: drugs}}
  end
end
