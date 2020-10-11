defmodule HippoAbsWeb.Router do
  use HippoAbsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", HippoAbsWeb do
    pipe_through :browser

    get "/", PageController, :index
  end


  pipeline :api do
    plug :accepts, ["json"]
    plug HippoAbsWeb.Plugs.Authentication, otp_app: :hippo_abs,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: HippoAbsWeb.FallbackController
  end

  pipeline :admin_authorized do
    plug HippoAbsWeb.Plugs.RoleAuthorization, type: 0
  end

  pipeline :dev_authorized do
    plug HippoAbsWeb.Plugs.RoleAuthorization, type: 1
  end

  pipeline :doc_authorized do
    plug HippoAbsWeb.Plugs.RoleAuthorization, type: 2
  end

  pipeline :pat_authorized do
    plug HippoAbsWeb.Plugs.RoleAuthorization, type: 3
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", HippoAbsWeb, as: :api_v1 do
    pipe_through :api

    # sign up
    resources "/registration", UserController, only: [:create]

    # login, logout, renew
    resources "/session", SessionController, only: [:create, :delete], singleton: true
    post "/session/renew", SessionController, :renew, singleton: true

    # for rabbitmq http auth
    post "/rabbitmq/auth/user", Rabbit.AuthController, :auth_user, singleton: true
    post "/rabbitmq/auth/vhost", Rabbit.AuthController, :auth_vhost, singleton: true
    post "/rabbitmq/auth/resource", Rabbit.AuthController, :auth_resource, singleton: true
    post "/rabbitmq/auth/topic", Rabbit.AuthController, :auth_topic, singleton: true

  end

  scope "/api/v1/admin", HippoAbsWeb.Admin, as: :admin do
    pipe_through [:api, :api_protected, :admin_authorized]

    # register
    resources "/registration", UserController, only: [:index]

    resources "/devices", DeviceController, only: [:index, :create, :update, :delete]
    resources "/services", ServiceController, only: [:index, :create, :update, :delete]
    resources "/farms", FarmController, only: [:index, :create, :update, :delete]


    get "/device/:device_id/services", ServiceController, :index
  end

  scope "/api/v1", HippoAbsWeb, as: :api_v1 do
    pipe_through [:api, :api_protected, :pat_authorized]

    # Your protected API endpoints here
    # search drug
    post "/drugs", PrescriptionController, :index_drugs
    get "/drug/:id", PrescriptionController, :show_drug

    # sign out
    resources "/registration", UserController, only: [:delete, :show], singleton: true

    # device
    resources "/devices", DeviceController, only: [:index, :create, :update, :delete]

    # service
    resources "/services", ServiceController, only: [:index, :create, :update, :delete]

    # prescription
    resources "/prescriptions", PrescriptionController, only: [:index, :create, :update, :delete]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test, :stg] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HippoAbsWeb.Telemetry
    end
  end
end
