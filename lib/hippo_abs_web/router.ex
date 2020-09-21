defmodule HippoAbsWeb.Router do
  use HippoAbsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug HippoAbsWeb.Plugs.Authorization, otp_app: :hippo_abs,
      error_handler: Pow.Phoenix.PlugErrorHandler
      # session_ttl_renewal: :timer.hours(24),
      # credentials_cache_store: {Pow.Store.CredentialsCache, ttl: :timer.hours(24)}
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: HippoAbsWeb.Plugs.AuthErrorHandler
  end

  scope "/", HippoAbsWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", HippoAbsWeb, as: :api_v1 do
    pipe_through :api

    resources "/registration", UserController, singleton: true, only: [:create]
    # resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session", SessionController, :create

    post "/session/renew", SessionController, :renew
  end

  scope "/api/v1", HippoAbsWeb, as: :api_v1 do
    pipe_through [:api, :api_protected]

    # Your protected API endpoints here
    get "/registration", UserController, :index
    delete "/registration", UserController, :delete
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HippoAbsWeb.Telemetry
    end
  end
end
