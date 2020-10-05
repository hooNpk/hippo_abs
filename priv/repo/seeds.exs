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


HippoAbs.Repo.insert!(%HippoAbs.Account.User{
    "user": {
        "name": "관리자",
        "email": "elixian@elixian.co.kr",
        "password": "12121212",
        "password_confirmation": "12121212",
        "type": 0
    }
})

HippoAbs.Repo.insert!(%HippoAbs.Account.User{
    "user": {
        "name": "의사 기본값",
        "email": "hospital@hospital.com",
        "password": "12121212",
        "password_confirmation": "12121212",
        "type": 2,
        "hospital_code": 11
    }
})
