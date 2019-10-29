use Mix.Config

# Configure your database
config :my_notes, MyNotes.Repo,
  username: "postgres",
  password: "postgres",
  database: "my_notes_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :my_notes, MyNotesWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
