defmodule Kno.Plug do
  @moduledoc """
  Utilies to for using Kno in a Plug, or Phoenix, application.

  This module works with a `conn` that that has passed through one of:

  - `Kno.Plug.Session`
  """
  import Phoenix.HTML, only: [sigil_E: 2]

  @doc """
  Fetch the persona_id of the authenticated user.

  If no user is authenticated returns `nil`.
  """
  def persona_id(conn) do
    {:ok, persona_id} = Map.fetch(conn.private, :kno_persona_id)
    # TODO create a kno.config error.
    persona_id
  end

  @doc """
  Display a sign in button, or sign out if user already authenticated. 
  """
  def session_buttons(conn) do
    %Kno.Config{cdn_host: cdn_host, site_token: site_token} = conn.private.kno_config

    case persona_id(conn) do
      nil ->
        ~E"""
        <form action="/session/new">
          <script
            src="<%= cdn_host %>/pass.js"
            data-site="<%= site_token %>">
          </script>
          <button type="submit">Sign in</button>
        </form>
        """

      _persona_id ->
        ~E"""
        <form action="/session/terminate">
          <button type="submit">Sign out</button>
        </form>

        """
    end
  end
end
