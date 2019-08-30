defmodule Knotes.Repo do
  use Ecto.Repo,
    otp_app: :knotes,
    adapter: Ecto.Adapters.Postgres
end
