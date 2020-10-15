defmodule HippoAbs.Repo do
  use Ecto.Repo,
    otp_app: :hippo_abs,
    adapter: Ecto.Adapters.Postgres


  def count(table) do
    aggregate(table, :count, :id)
  end
end
