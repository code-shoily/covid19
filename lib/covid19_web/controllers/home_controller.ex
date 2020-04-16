defmodule Covid19Web.HomeController do
  use Covid19Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
