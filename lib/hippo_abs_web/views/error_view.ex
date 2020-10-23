defmodule HippoAbsWeb.ErrorView do
  use HippoAbsWeb, :view

  require Logger

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  def render("500.json", _assigns) do
    %{errors: %{message: "Internal Server Error"}}
  end

  def render("400.json", _assigns) do
    %{errors: %{message: "Resource not found"}}
  end

  def render("error.json", %{changeset: params}) do
    Logger.error(inspect params)
    %{errors: translate_errors(params)}
  end

  def render("error.json", %{error: reason}) do
    Logger.error(inspect reason)
    %{errors: reason}
  end

  defp translate_errors(changeset) do
    # Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opt} ->
      Enum.reduce(opt, %{}, fn x, acc ->
        Map.put(acc, elem(x, 0), elem(x, 1))
      end)
      |> Map.put_new("msg", msg)
    end)
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
