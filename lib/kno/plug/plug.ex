defmodule Kno.Plug do
  import Phoenix.HTML, only: [sigil_E: 2]

  def persona_id(conn) do
    {:ok, persona_id} = Map.fetch(conn.private, :kno_persona_id)
    # TODO create a kno.config error.
    persona_id
  end

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
