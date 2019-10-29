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

  alias MyNotesWeb.Router.Helpers, as: Routes

  scope "/notes", MyNotesWeb do
    pipe_through [:browser, :ensure_authenticated]

    resources "/", NoteController
  end

  def ensure_authenticated(conn, _) do
    case get_session(conn, :persona_id) do
      nil ->
        conn
        |> put_flash(:error, "You don't have permission to access that page")
        |> redirect(to: Routes.page_path(conn, :index))
        |> halt()

      persona_id when is_binary(persona_id) ->
        conn
        |> assign(:persona_id, persona_id)
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyNotesWeb do
  #   pipe_through :api
  # end
end
