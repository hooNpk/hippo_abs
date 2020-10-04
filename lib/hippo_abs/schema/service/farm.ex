defmodule HippoAbs.Service.Farm do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder, only: [
      :id, :ip, :name, :inserted_at, :updated_at
    ]
  }

  schema "farms" do
    field :ip, :string
    field :name, :string
    has_many :tokens, HippoAbs.Service.Token

    timestamps([type: :utc_datetime_usec])
  end

  @doc false
  def changeset(farm, attrs) do
    farm
    |> cast(attrs, [:name, :ip])
    |> validate_required([:name, :ip])
  end
end
