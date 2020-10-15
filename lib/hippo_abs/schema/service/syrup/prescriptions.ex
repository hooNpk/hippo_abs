defmodule HippoAbs.Service.Syrup.Prescription do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder, only: [
      :id, :user_id, :doctor_id, :dosage, :start_date, :end_date, :inserted_at, :updated_at
    ]
  }

  schema "prescriptions" do
    field :end_date, :date
    field :start_date, :date
    belongs_to :user, HippoAbs.Account.User, foreign_key: :user_id
    belongs_to :doctor, HippoAbs.Account.User, foreign_key: :doctor_id
    has_many :dosage, HippoAbs.Service.Syrup.Dosage

    timestamps([type: :utc_datetime_usec])
  end

  @doc false
  def changeset(syrup, attrs) do
    syrup
    |> cast(attrs, [:start_date, :end_date])
    |> validate_required([:start_date, :end_date])
  end
end
