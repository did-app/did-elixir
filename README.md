# Kno Elixir

Documentation and examples for using [trykno.com](https://trykno.com) in Elixir applications

- [Phoenix integration guide](#phoenix-integration-guide)

# Phoenix integration guide

*This guide requires Phoenix and Elixir.
The [Phoenix install guide](https://hexdocs.pm/phoenix/installation.html#content) can help you get both of these set up.*

## Setup project

Let's start a new project for a note taking app, which we shall call `my_notes`.
We will use Kno to authenticate users and start a session for them.

Kno is great for applications like this, it gives users a slick password free authentication that takes you only a few minutes to integrate.

If you want to try our device based authentication with your local app visit [trykno.app](https://trykno.app) on your mobile.

```sh
mix phx.new my_notes --no-webpack
```

Open up `mix.exs` and add HTTPoison and Jason as dependencies.

```elixir
defp deps do
  [
    # existing dependencies
    {:jason, "~> 1.1"},
    {:httpoison, "~> 1.6"},
  ]
end
```

Then run `mix deps.get` to pull the new dependencies.

Next setup the tokens associated without your application.
Add the following code to `config/dev.exs`

```elixir
config :my_notes,
  kno_site_token: "kno_local_site_token",
  kno_api_token: "alpha.kno_local_site_token.kno_local_api_key"
```

*For production you will have keys unique to your application.
However you can use the tokens in this example as long as your example is running from localhost.*

**Please note that emails will be sent so you can test.
Ensure you use real emails so not to get blocked from using these credentials for local development**

## Display sign in/out buttons

Add the following code to `lib/my_notes_web/templates/layout/app.html.eex`, so that a user can sign in or out from any page.

```eex
<%= if authenticated?(@conn) do %>
  <%= link "Sign out", to: Routes.session_path(@conn, :sign_out) %>
<% else %>
  <%= form_for @conn, Routes.session_path(@conn, :sign_in), fn _form -> %>
    <script
      src="https://trykno.app/pass.js"
      data-site=<%= Application.get_env(:my_notes, :kno_site_token) %>>
    </script>
    <%= submit "Sign in" %>
  <% end %>
<% end %>
```

The `authenticated?` function is a helper that we define later.

For authenticated users a link to sign out is shown.
This link points to the `:sign_out` action found on the `MyNotesWeb.Session` controller.

Authenticated users see a button that will start the process of signing in.

Here we are using the [simple Kno integration](https://trykno.com/docs/#kno-now) as it is fastest way to get started.
When the form is submitted a sign in overlay is shown and once the user has been authenticated a pass token is added to the form.
This form, and the pass token within it is submitted to the`:sign_in` action on the `MyNotesWeb.Session` controller.

The helper function to tell if our user is authenticated is defined in `lib/my_notes_web/views/layout_view.ex`.

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

  def sign_in(conn, %{"knoToken" => token}) do
    persona_id = verify_token!(token)

    conn
    |> put_session(:persona_id, persona_id)
    |> redirect(to: "/")
  end

  def sign_out(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: "/")
  end

  defp verify_token!(token) do
    api_token = Application.get_env(:my_notes, :kno_api_token)

    url = "https://api.trykno.app/v0/pass"
    headers = [
      {"authorization", "Basic #{Base.encode64(api_token <> ":")}"},
      {"content-type", "application/json"}
    ]
    body = Jason.encode!(%{token: token})

    %{status_code: 200, body: response_body} = HTTPoison.post!(url, body, headers)
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
