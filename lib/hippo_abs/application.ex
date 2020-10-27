defmodule HippoAbs.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      HippoAbs.Repo,
      # {HippoAbs.Repo, strategy: :one_for_one, max_restarts: 10_000, max_seconds: 18_000},
      # Start the Telemetry supervisor
      HippoAbsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HippoAbs.PubSub},
      # Start the Endpoint (http/https)
      HippoAbsWeb.Endpoint
      # Start a worker by calling: HippoAbs.Worker.start_link(arg)
      # {HippoAbs.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HippoAbs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HippoAbsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
