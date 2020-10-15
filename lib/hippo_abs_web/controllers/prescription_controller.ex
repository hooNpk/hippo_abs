defmodule HippoAbsWeb.PrescriptionController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.{SyrupContext, Account}

  action_fallback HippoAbsWeb.FallbackController


  def index(conn, _params, current_user) do
    # Logger.warn(inspect params)
    with  user when not is_nil(user) <- current_user,
          prescriptions when prescriptions != [] <- SyrupContext.list_prescriptions(user) do
            conn
            |> render("index.json", %{data: %{prescriptions: prescriptions}})
    end
  end

  def create(conn, %{"prescription" => prescription_params, "dosage" => dosage_params}, current_user) do
    with  doctor when not is_nil(doctor) <- Account.get_user(2),  # default doctor
          {:ok, prescription} <- SyrupContext.create_prescription_and_dosage(current_user, doctor, prescription_params, dosage_params) do
            Logger.warn(inspect prescription)
            conn
            |> render("show.json", %{data: %{prescription: prescription}})
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    with  user when not is_nil(user) <- current_user,
          prescription when prescription != [] <- SyrupContext.get_prescription_by(user, id) do
            conn
            |> render("show.json", %{data: %{prescription: prescription}})
    end
  end

  def delete(conn, %{"id" => id}, _current_user) do
    with  {:ok, prescription} <- SyrupContext.delete_prescription(String.to_integer(id)) do
      conn
      |> render("show.json", %{data: %{prescription: prescription}})
    end
  end


  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
end
