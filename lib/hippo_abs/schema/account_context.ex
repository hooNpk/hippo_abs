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

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  def authenticate(params) do
    pow_authenticate(params)
  end

  def create_user(attrs \\ %{}) do
    Logger.warn("HippoAbs.Account.create(#{inspect attrs})")
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
