defmodule HippoAbsWeb.DosageController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.{SyrupContext}

  action_fallback HippoAbsWeb.FallbackController


  def index(conn, %{"prescription_id" => prescription_id}, current_user) do
    # Logger.warn(inspect params)
    with  user when not is_nil(user) <- current_user,
          prescription when prescription != [] <- SyrupContext.get_prescription_by(user, prescription_id),
          dosage when dosage != [] <- SyrupContext.list_dosage_by(prescription) do
            conn
            |> render("index.json", %{data: %{dosage: dosage}})
    end
  end

  def create(conn, %{"prescription_id" => prescription_id, "dosage" => dosage_params}, current_user) do
    with  user when not is_nil(user) <- current_user,
          prescription <- SyrupContext.get_prescription(prescription_id),
          # {:ok, dosage} <- SyrupContext.create_dosage(prescription, dosage_params) do
          {:ok, dosage} when dosage != [] <- SyrupContext.create_dosage_multi(prescription, dosage_params) do
            conn
            |> render("show.json", %{data: %{dosage: dosage}})
    end
  end

  def show(conn, %{"prescription_id" => prescription_id, "id" => id}, _current_user) do
    with  prescription when not is_nil(prescription) <- SyrupContext.get_prescription(prescription_id),
          dosage when not is_nil(dosage) <- SyrupContext.get_dosage_by(prescription, id) do
            conn
            |> render("show.json", %{data: %{dosage: dosage}})
    end
  end

  def delete(conn, %{"prescription_id" => prescription_id, "id" => id}, _current_user) do
    with  prescription when not is_nil(prescription) <- SyrupContext.get_prescription(prescription_id),
          {:ok, dosage} <- SyrupContext.delete_dosage(id) do
            conn
            |> render("show.json", %{data: %{dosage: dosage}})
    end
  end


  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
end
