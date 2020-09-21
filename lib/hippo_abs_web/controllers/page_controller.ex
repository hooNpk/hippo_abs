defmodule HippoAbsWeb.PageController do
  use HippoAbsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
