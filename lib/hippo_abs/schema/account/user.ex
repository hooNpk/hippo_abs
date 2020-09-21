defmodule HippoAbs.Account.User do
  use Ecto.Schema
  use Pow.Ecto.Schema,
    user_id_field: :email,
    password_hash_methods: {&Pow.Ecto.Schema.Password.pbkdf2_hash/1, &Pow.Ecto.Schema.Password.pbkdf2_verify/2},
    password_min_length: 8,
    password_max_length: 32

  import Ecto.Changeset
  require Logger

  @derive {Jason.Encoder, only: [:id, :name, :email, :type, :phonenum, :birth, :hospital_code, :gender]}

  schema "users" do
    field :name, :string
    field :type, :integer
    field :phonenum, :string
    field :gender, :integer
    field :birth, :date
    field :hospital_code, :integer

    pow_user_fields()

    timestamps([type: :utc_datetime_usec])
  end

  def changeset(user_or_changeset, attrs) do
    Logger.warn(inspect attrs)
    user_or_changeset
    |> pow_changeset(attrs)
    |> cast(attrs, [:name, :phonenum])
    |> validate_required([:name, :phonenum])
    |> validate_length(:name, min: 2, max: 32)
    |> validate_format(:phonenum, ~r"^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$")
  end

  def registration_patient_changeset(user_or_changeset, attrs) do
    Logger.warn("user.change: #{inspect attrs}")
    user_or_changeset
    |> changeset(attrs)
    |> cast(attrs, [:type, :gender, :birth])
    |> validate_required([:type, :gender, :birth])
    |> validate_number(:type, equal_to: 2)
    |> validate_number(:gender, less_than_or_equal_to: 1, greater_than_or_equal_to: 0)
  end

  def registration_doctor_changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> changeset(attrs)
    |> cast(attrs, [:type, :hospital_code])
    |> validate_required([:type, :hospital_code])
    |> validate_number(:type, equal_to: 3)
    |> validate_number(:hospital_code, greater_than: 10, less_than: 99)
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pw}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pw))
      _ ->
        changeset
    end
  end
end
