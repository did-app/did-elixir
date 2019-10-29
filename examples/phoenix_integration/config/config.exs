# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :my_notes,
  ecto_repos: [MyNotes.Repo]

# Configures the endpoint
config :my_notes, MyNotesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ea1tfZVhtcvUkx4QBZGdxEClgfsODin4+dqbH0htgY04ysQuBxO2GdsFlxahVOJc",
  render_errors: [view: MyNotesWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MyNotes.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
