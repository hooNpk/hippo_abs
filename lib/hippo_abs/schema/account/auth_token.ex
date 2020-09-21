defmodule HippoAbs.Account.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:token]}

  schema "auth_tokens" do
    field :revoked, :boolean, default: false
    field :revoked_at, :utc_datetime
    field :token, :string
    belongs_to :user, HippoAbs.Account.User

    timestamps([type: :utc_datetime_usec])
  end

  @doc false
  def changeset(auth_token, attrs) do
    auth_token
    |> cast(attrs, [:token, :revoked, :revoked_at])
    |> validate_required([:token, :revoked, :revoked_at])
    |> unique_constraint(:token)
  end

  def changeset_update(auth_token, attrs) do
    auth_token
    |> cast(attrs, [:revoked, :revoked_at])
    |> validate_required([:revoked, :revoked_at])
  end
end
