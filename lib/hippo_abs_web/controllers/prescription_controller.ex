defmodule HippoAbsWeb.PrescriptionController do
  use HippoAbsWeb, :controller
  require Logger

  alias HippoAbs.{SyrupContext, Account}

  action_fallback HippoAbsWeb.FallbackController


  def index(conn, params, current_user) do
    Logger.warn(inspect params)
    with  user when not is_nil(user) <- current_user,
          prescriptions when not is_nil(prescriptions) <- SyrupContext.list_prescriptions(user) do
            conn
            |> render("index.json" ,%{data: %{prescriptions: prescriptions}})
    end
  end


  def create(conn, %{"prescription" => prescription_params, "pills" => pills_params}, current_user) do
    with  doctor when not is_nil(doctor) <- Account.get_user(1),  # default doctor
          {:ok, prescription} <- SyrupContext.create_prescription(current_user, doctor, prescription_params),
          :ok <- SyrupContext.create_pills(prescription, pills_params) do
      conn
      |> render("show.json", %{data: %{prescription_id: prescription.id}})
    end
  end


  def delete(conn, %{"id" => id}, _current_user) do
    with  {:ok, prescription} <- SyrupContext.delete_prescription(String.to_integer(id)) do
      conn
      |> render("show.json", prescription: prescription)
    end
  end


  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
end
