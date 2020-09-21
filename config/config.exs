# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hippo_abs,
  ecto_repos: [HippoAbs.Repo]

# Configures the endpoint
config :hippo_abs, HippoAbsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vxJWK+841HQzE3XRkeUmqYIAAbcjq/ixTt+2rsEhS8RNX+Sk0hV6Qo0l06FBPXAF",
  render_errors: [view: HippoAbsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HippoAbs.PubSub,
  live_view: [signing_salt: "vzcVy8lS"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


config :hippo_abs, :pow,
  user: HippoAbs.Account.User,
  repo: HippoAbs.Repo,
  users_context: HippoAbs.Account

config :pow,
  # ttl: :timer.hours(1)
  ttl: :timer.minutes(1)


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
