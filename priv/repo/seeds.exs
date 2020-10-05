# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HippoAbs.Repo.insert!(%HippoAbs.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


HippoAbs.Account.create_user(%{
    "name": "관리자",
    "email": "elixian@elixian.co.kr",
    "password": "12121212",
    "password_confirmation": "12121212",
    "type": 0,
})


HippoAbs.Account.create_user(%{
    "name": "화타",
    "email": "hospital@gmail.com",
    "password": "12121212",
    "password_confirmation": "12121212",
    "type": 2,
    "hospital_code": 11
})
