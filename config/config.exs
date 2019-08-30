# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :knotes,
  ecto_repos: [Knotes.Repo]

# Configures the endpoint
config :knotes, KnotesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "R9C8tOD53JlU+vMOCUhvqtmDipCAZ4qtyhjQ+PnlT7cQKzY+DIhWqKZE9SH0q4Zf",
  render_errors: [view: KnotesWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Knotes.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
