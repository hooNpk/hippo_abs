defmodule HippoAbsWeb.DrugController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.{SyrupContext}

  action_fallback HippoAbsWeb.FallbackController


  # Search Drugs
  def search(conn, %{"term" => term, "limit" => limit, "offset" => offset}, current_user) do
    with  user when not is_nil(user) <- current_user,
          drugs when not is_nil(drugs) <- SyrupContext.list_drugs(term, limit, offset) do
            conn
            |> render("index.json", %{data: %{drugs: drugs}})
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    with  user when not is_nil(user) <- current_user,
          drug when not is_nil(drug) <- SyrupContext.get_drug(id) do
            conn
            |> render("show.json", %{data: %{drug: drug}})
    end
  end


  # Drug References
  def index(conn, %{"prescription_id" => prescription_id, "dosage_id" => dosage_id}, current_user) do
    with  user when not is_nil(user) <- current_user,
          prescription when prescription != [] <- SyrupContext.get_prescription_by(user, prescription_id),
          dosage when not is_nil(dosage) <- SyrupContext.get_dosage_by(prescription, dosage_id),
          drugs when drugs != [] <- SyrupContext.list_drug_references(dosage) do
            conn
            |> render("index.json", %{data: %{drugs: drugs}})
    end
  end

  def create(conn, %{"dosage_id" => dosage_id, "drugref" => drug_params}, current_user) when is_list(drug_params) do
    Logger.warn(inspect drug_params)
    with  user when not is_nil(user) <- current_user,
          {:ok, ids} <- SyrupContext.create_drug_references(dosage_id, drug_params) do
            conn
            |> render("index.json", %{data: %{drugs: ids}})
    end
  end

  def create(conn, %{"dosage_id" => dosage_id, "drugref" => drug_params}, current_user) do
    with  user when not is_nil(user) <- current_user,
          {:ok, id} <- SyrupContext.create_drug_references(dosage_id, drug_params) do
            conn
            |> render("show.json", %{data: %{drug: id}})
    end
  end


  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
end
