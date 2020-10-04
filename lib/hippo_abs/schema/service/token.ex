defmodule HippoAbs.Service.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tokens" do
    field :token, :string
    belongs_to :farm, HippoAbs.Service.Farm

    timestamps([type: :utc_datetime_usec])
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:token])
    |> validate_required([:token])
    |> validate_length(:token, max: 64)
    |> unique_constraint([:farm_id, :token])
  end

  def changeset(token, attrs, farm) do
    token
    |> changeset(attrs)
    |> put_assoc(:farm, farm)
  end
end
