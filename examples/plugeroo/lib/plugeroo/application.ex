defmodule Plugeroo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Plugeroo, options: [port: 4001]}
      # Starts a worker by calling: Plugeroo.Worker.start_link(arg)
      # {Plugeroo.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Plugeroo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
