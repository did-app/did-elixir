defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyAppWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/session/authenticate", SessionController, :authenticate
    get "/session/callback", SessionController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyAppWeb do
  #   pipe_through :api
  # end
end
