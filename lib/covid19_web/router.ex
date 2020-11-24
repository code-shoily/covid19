defmodule Covid19Web.Router do
  use Covid19Web, :router

  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", Covid19Web do
    pipe_through :browser

    live "/", DashboardLive, layout: {Covid19Web.LayoutView, "app.html"}
    live "/detail/:country_or_region", DetailLive, layout: {Covid19Web.LayoutView, "app.html"}
    live_dashboard "/dashboard", metrics: Covid19.Telemetry, ecto_repos: [Covid19.Repo]
  end
end
