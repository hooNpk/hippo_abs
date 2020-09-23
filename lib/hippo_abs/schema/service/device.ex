defmodule HippoAbs.Service.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field :device_id, :string
    field :name, :string
    belongs_to :user, HippoAbs.Account.User

    timestamps([type: :utc_datetime_usec])
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:name, :device_id])
    |> validate_required([:name, :device_id])
  end
end
