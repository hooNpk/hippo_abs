defmodule HippoAbs.Service.Token do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  @derive {
    Jason.Encoder, only: [
      :id, :token, :farm, :inserted_at, :updated_at
    ]
  }

  schema "tokens" do
    field :token, :string
    belongs_to :farm, HippoAbs.Service.Farm

    timestamps([type: :utc_datetime_usec])
  end

  @doc false
  def changeset(token \\ %Token{}, attrs) do
    token
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
