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
    "name" => "관리자",
    "uid" => "elixian@elixian.co.kr",
    "password" => "12121212",
    "password_confirmation" => "12121212",
    "type" => 0,
})

HippoAbs.Account.create_user(%{
    "name" => "화타",
    "uid" => "hospital@gmail.com",
    "password" => "12121212",
    "password_confirmation" => "12121212",
    "type" => 2,
    "hospital_code" => 9999
})

HippoAbs.ServiceContext.create_farm(%{
    "ip" => "127.0.0.1",
    "name" => "Syrup 서비스 Farm"
})

HippoAbs.ServiceContext.create_farm(%{
    "ip" => "127.0.0.1",
    "name" => "DIB 서비스 Farm"
})

HippoAbs.ServiceContext.create_farm(%{
    "ip" => "127.0.0.1",
    "name" => "DIB 서비스 Farm (임상용)"
})
