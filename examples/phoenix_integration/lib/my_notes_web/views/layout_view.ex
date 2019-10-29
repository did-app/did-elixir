defmodule MyNotesWeb.LayoutView do
  use MyNotesWeb, :view

  def authenticated?(conn) do
    case Plug.Conn.get_session(conn, :persona_id) do
      persona_id when is_binary(persona_id) ->
        true

      nil ->
        false
    end
  end
end
