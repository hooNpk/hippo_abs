defmodule HippoAbs.Account do
  use Pow.Ecto.Context,
    repo: HippoAbs.Repo,
    user: HippoAbs.Account.User

  import Ecto.Query, warn: false

  alias HippoAbs.Repo
  alias HippoAbs.Account.User

  require Logger


  def list_users do
    Repo.all(User)
  end

  def get_user(id), do: Repo.get(User, id)

  def get_user_by_uid(uid), do: Repo.get_by(User, uid: uid)

  def authenticate(params) do
    pow_authenticate(params)
  end

  def create(attrs) do
    {_value, attrs} =
      Map.get_and_update(attrs, "uid", fn value ->
        {value, String.downcase(value)}
      end)

    Logger.warn("HippoAbs.Account.create_user(#{inspect attrs})")
    pow_create(attrs)
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> pow_update(attrs)
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
