defmodule MyNotes.Repo do
  use Ecto.Repo,
    otp_app: :my_notes,
    adapter: Ecto.Adapters.Postgres
end
