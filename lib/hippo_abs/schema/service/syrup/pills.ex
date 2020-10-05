defmodule HippoAbs.Service.Syrup.Pills do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder, only: [
      :id, :name, :period, :count, :amout, :detail, :inserted_at, :updated_at
    ]
  }

  schema "pills" do
    field :amout, :integer
    field :count, :integer
    field :detail, :integer
    field :name, :string
    field :period, :integer
    belongs_to :prescription, HippoAbs.Service.Syrup.Prescription


    timestamps([type: :utc_datetime_usec])
  end

  @doc false
  def changeset(pills, attrs) do
    pills
    |> cast(attrs, [:period, :detail, :count, :name, :amout])
    |> validate_required([:period, :detail, :count, :name, :amout])
  end

  def changeset(pill, prescription, attrs) do
    pill
    |> changeset(attrs)
    |> put_assoc(:prescription, prescription)
  end
end
