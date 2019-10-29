defmodule MyNotesWeb.Router do
  use MyNotesWeb, :router

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

  scope "/", MyNotesWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/sign-in", SessionController, :sign_in
    get "/sign-out", SessionController, :sign_out
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyNotesWeb do
  #   pipe_through :api
  # end
end
