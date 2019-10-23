# Kno Elixir

Documentation and examples for using [trykno.com](https://trykno.com) in Elixir applications

- [Phoenix integration guide](#phoenix-integration-guide)

# Phoenix integration guide

*This guide requires Phoenix and Elixir.
The [Phoenix install guide](https://hexdocs.pm/phoenix/installation.html#content) can help you get both of these set up.*

## Setup project

Let's start a new project.

```sh
mix phx.new my_notes --no-webpack
```

## Display sign in or sign out button

Our unauthenticated users need a sign in button to click.
Once signed in our users need a button to sign out.

In `lib/my_notes_web/views/layout_view.ex` create a helper function to tell if our user is authenticated or not.

```elixir
def authenticated?(conn) do
  case Plug.Conn.get_session(conn, :persona_id) do
    persona_id when is_binary(persona_id) ->
      true

    nil ->
      false
  end
end
```

A session with a `persona_id` present is authenticated for that persona, otherwise unauthenticated.

Add the following code to `lib/my_notes_web/templates/layout/app.html.eex`, so that a user can sign in or out from any page.

```eex
<%= if authenticated?(conn) do %>
  <%= link "Sign out", to: Routes.session_path(@conn, :sign_out) %>
<% else %>
  <%= form_for @conn, Routes.session_path(@conn, :sign_in), fn _form -> %>
    <script
      src="https://trykno.app/pass.js"
      data-site=<%= Application.get_env(:my_app, :kno_site_token) %>>
    </script>

    <%= submit "Sign in" %>
  <% end %>
<% end %>
```

Authenticated users see a link to the `sign_out` action found on the `MyNotesWebs.Session` controller.
For unauthenticated users a form that will submit to the `sign_in` action on the `MyNotesWebs.Session` controller is displayed.

Inside the form we use the Kno [HTML integration](https://trykno.com/docs/#kno-now).
The `pass.js` script automatically handles authenticating users when inside a form tag.
The script requires that a site token is set, we are pulling the site token from the application configuration for our application.
When the user clicks the sign in button they will be authenticated.
A one time `passToken` will be added to the form before it is submitted to the `sign_in` action.

*The Kno integration works the same way for sign-in and sign-up, therefore we only need to show one button.*

## Create our session controller

The router needs to know about the actions we are adding to our session controller.
In `lib/my_notes_web/router.ex` add the two routes to the top level `"/"` scope.

```elixir
scope "/", HelloWeb do
  pipe_through :browser

  get "/", PageController, :index
  post "/sign-in", SessionController, :sign_in
  get "/sign-out", SessionController, :sign_out
end
```

Next, let's create our session controller and add these actions.

```elixir
defmodule MyNotesWeb.SessionController do
  use MyNotesWeb, :controller

  def create(conn, %{"knoToken" => token}) do
    persona_id = verify_token!(token)

    conn
    |> put_session(:persona_id, persona_id)
    |> redirect(to: "/")
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: "/")
  end

  defp verify_token!(token) do
    api_token = Application.get_env(:my_notes, :kno_api_token)

    url = "https://api.trykno.app/v0/pass"
    headers = [
      {"authorization", "Bearer #{api_token}"},
      {"content-type", "application/json"}
    ]
    body = Jason.encode!(%{token: token})

    %{status_code: 200, body: response_body} = HTTPoison.post!(url, headers, body)
    %{"persona" => %{"id" => persona_id}} = Jason.decode!(response_body)
    persona_id
  end
end
```

## CRUD for notes

Now we know who are user is they should be able to Create Read Update & Delete (CRUD) their notes.
Let's create a new `MyNotesWeb.NotesController`, don't forget we will need to add all these actions to the router

```elixir
defmodule MyNotesWeb.NotesController do
  use MyNotesWeb, :controller

  plug :ensure_authenticated

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

  def create(conn, %{note: note_params}) do
    %{persona_id: persona_id} = conn.assigns

    # Or just have a function you call
    note = %Note{persona_id: persona_id}
    |> Note.changeset(attrs)
    |> MyNotes.Repo.insert()
  end
end
```
