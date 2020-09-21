defmodule HippoAbs.Repo do
  use Ecto.Repo,
    otp_app: :hippo_abs,
    adapter: Ecto.Adapters.Postgres
end
