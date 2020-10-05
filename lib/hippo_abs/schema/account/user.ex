defmodule HippoAbs.Account.User do
  use Ecto.Schema
  use Pow.Ecto.Schema,
    user_id_field: :email,
    password_hash_methods: {&Pow.Ecto.Schema.Password.pbkdf2_hash/1, &Pow.Ecto.Schema.Password.pbkdf2_verify/2},
    password_min_length: 8,
    password_max_length: 32

  import Ecto.Changeset
  require Logger

  @derive {
    Jason.Encoder, only: [
      :id,
      :name,
      :email,
      :type,
      :phonenum,
      :birth,
      :hospital_code,
      :gender,
      :inserted_at,
      :updated_at
    ]
  }

  schema "users" do
    field :name, :string
    field :type, :integer
    field :phonenum, :string
    field :gender, :integer
    field :birth, :date
    field :hospital_code, :integer
    has_many :device, HippoAbs.Service.Device
    has_many :prescription, HippoAbs.Service.Syrup.Prescription

    pow_user_fields()

    timestamps([type: :utc_datetime_usec])
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> cast(attrs, [:name, :type])
    |> validate_required([:name, :type])
    |> validate_length(:name, min: 2, max: 32)
    |> validate_number(:type, less_than_or_equal_to: 3, greater_than_or_equal_to: 0)
    |> change_user(attrs)
    |> change_doctor(attrs)
    |> change_developer(attrs)
    |> change_admin(attrs)
  end

  def change_user(user_or_changeset, %{"type" => 3} = attrs) do
    user_or_changeset
    |> cast(attrs, [:phonenum, :gender, :birth])
    |> validate_required([:phonenum, :gender, :birth])
    |> validate_format(:phonenum, ~r"^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$")
    |> validate_number(:gender, less_than_or_equal_to: 1, greater_than_or_equal_to: 0)
  end
  def change_user(user_or_changeset, _), do: user_or_changeset

  def change_doctor(user_or_changeset, %{"type" => 2} = attrs) do
    user_or_changeset
    |> cast(attrs, [:hospital_code])
    |> validate_required([:hospital_code])
    |> validate_number(:hospital_code, greater_than: 10, less_than: 99)
  end
  def change_doctor(user_or_changeset, _), do: user_or_changeset

  def change_developer(user_or_changeset, %{"type" => 1} = _attrs), do: user_or_changeset
  def change_developer(user_or_changeset, _), do: user_or_changeset

  def change_admin(user_or_changeset, %{"type" => 0} = _attrs), do: user_or_changeset
  def change_admin(user_or_changeset, _), do: user_or_changeset

  # defp put_password_hash(changeset) do
  #   case changeset do
  #     %Ecto.Changeset{valid?: true, changes: %{password: pw}} ->
  #       put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pw))
  #     _ ->
  #       changeset
  #   end
  # end
end
