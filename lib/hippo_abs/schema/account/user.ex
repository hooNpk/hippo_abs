defmodule HippoAbs.Account.User do
    @moduledoc ~S"""
    ## 회원 타입 구분

    * 0: 관리자
    * 1: 개발자
    * 2: 의사
    * 3: 환자
    * 4: 임상실험 대상자

    ## 각 회원 타입 별, 서비스 시나리오

    TODO

  """
  use Ecto.Schema

  use Pow.Ecto.Schema,
    user_id_field: :uid,
    password_hash_methods: {&Pow.Ecto.Schema.Password.pbkdf2_hash/1, &Pow.Ecto.Schema.Password.pbkdf2_verify/2},
    password_min_length: 8,
    password_max_length: 32

  import Ecto.Changeset
  require Logger

  @derive {
    Jason.Encoder, only: [
      :id,
      :name,
      :uid,
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
    field :uid, :string, null: false
    field :name, :string
    field :type, :integer
    field :phonenum, :string
    field :gender, :integer
    field :birth, :date
    field :hospital_code, :integer
    has_many :device, HippoAbs.Service.Device
    has_many :prescription, HippoAbs.Service.Syrup.Prescription

    # pow_user_fields()
    field :password_hash,    :string
    field :current_password, :string, virtual: true
    field :password,         :string, virtual: true
    field :confirm_password, :string, virtual: true

    timestamps([type: :utc_datetime_usec])
  end

  @spec changeset(any, any) :: any
  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> change_trial(attrs)
    |> change_user(attrs)
    |> change_doctor(attrs)
    |> change_developer(attrs)
    |> change_admin(attrs)
    |> cast(attrs, [:name, :type])
    |> validate_required([:name, :type])
    |> validate_length(:name, min: 2, max: 32)
    |> validate_number(:type, less_than_or_equal_to: 4, greater_than_or_equal_to: 0)
  end

  def change_trial(user_or_changeset, %{"type" => 4} = attrs) do
    user_or_changeset
    # |> pow_changeset(attrs)
    |> cast(attrs, [:uid, :gender, :birth])
    |> validate_required([:uid, :gender, :birth])
    |> validate_number(:gender, less_than_or_equal_to: 1, greater_than_or_equal_to: 0)
    |> unique_constraint([:uid], name: :users_uid_index)
  end
  def change_trial(user_or_changeset, _), do: user_or_changeset

  def change_user(user_or_changeset, %{"type" => 3} = attrs) do
    user_or_changeset
    # |> pow_changeset(attrs)
    |> cast(attrs, [:phonenum, :gender, :birth])
    |> validate_email(:uid)
    |> validate_required([:phonenum, :gender, :birth])
    |> validate_format(:phonenum, ~r"^01([0|1|6|7|8|9])-?([0-9]{3,4})-?([0-9]{4})$")
    |> validate_number(:gender, less_than_or_equal_to: 1, greater_than_or_equal_to: 0)
  end
  def change_user(user_or_changeset, _), do: user_or_changeset

  def change_doctor(user_or_changeset, %{"type" => 2} = attrs) do
    user_or_changeset
    # |> pow_changeset(attrs)
    |> cast(attrs, [:hospital_code])
    |> validate_email(:uid)
    |> validate_required([:hospital_code])
    |> validate_number(:hospital_code, greater_than: 10, less_than: 10000)
  end
  def change_doctor(user_or_changeset, _), do: user_or_changeset

  def change_developer(user_or_changeset, %{"type" => 1} = attrs) do
    user_or_changeset
    # |> pow_changeset(attrs)
    |> cast(attrs, [])
    |> validate_email(:uid)
  end
  def change_developer(user_or_changeset, _), do: user_or_changeset

  def change_admin(user_or_changeset, %{"type" => 0} = attrs) do
    user_or_changeset
    # |> pow_changeset(attrs)
    |> cast(attrs, [])
    |> validate_email(:uid)
  end
  def change_admin(user_or_changeset, _), do: user_or_changeset

  defp validate_email(changeset, field) do
    changeset
    |> validate_change(field, fn field, email ->
      Pow.Ecto.Schema.Changeset.validate_email(email)
      |> case do
        :ok -> []
        {:error, message} -> [{field, message}]
      end
    end)
  end
end
