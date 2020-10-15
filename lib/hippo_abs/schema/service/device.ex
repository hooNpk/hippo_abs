defmodule HippoAbs.Service.Device do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder, only: [
      :id, :device_id, :name, :inserted_at, :updated_at
    ]
  }

  schema "devices" do
    field :device_id, :string
    field :name, :string
    belongs_to :user, HippoAbs.Account.User
    has_many :services, HippoAbs.Service.Service

    timestamps([type: :utc_datetime_usec])
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:name, :device_id])
    |> validate_required([:name, :device_id])
    |> unique_constraint([:name, :device_id], name: :devices_user_id_device_id_index)
  end
end
