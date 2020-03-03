defmodule MyApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      {OpenIDConnect.Worker, did: did_config()},
      MyAppWeb.Endpoint
      # Starts a worker by calling: MyApp.Worker.start_link(arg)
      # {MyApp.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MyAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp did_config() do
    client_id = System.get_env("CLIENT_ID")
    client_secret = System.get_env("CLIENT_SECRET")

    [
      discovery_document_uri: "https://did.app/.well-known/openid-configuration",
      client_id: client_id,
      client_secret: client_secret,
      redirect_uri: "http://localhost:4000/session/callback",
      response_type: "code",
      scope: "openid"
    ]
  end
end
