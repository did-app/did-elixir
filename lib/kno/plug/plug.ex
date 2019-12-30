defmodule Kno.Plug do
  import Phoenix.HTML, only: [sigil_E: 2]

  def session_buttons(conn) do
    %Kno.Config{cdn_host: cdn_host, site_token: site_token} = conn.private.kno_config

    case Map.fetch(conn.private, :kno_persona_id) do
      {:ok, nil} ->
        ~E"""
        <form action="/session/new">
          <script
            src="<%= cdn_host %>/pass.js"
            data-site="<%= site_token %>">
          </script>
          <button type="submit">Sign in</button>
        </form>
        """

      {:ok, _persona_id} ->
        ~E"""
        <form action="/session/terminate">
          <button type="submit">Sign out</button>
        </form>

        """
    end
  end
end
