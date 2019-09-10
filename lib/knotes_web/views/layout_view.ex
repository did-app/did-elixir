defmodule KnotesWeb.LayoutView do
  use KnotesWeb, :view

  def signed_in?(conn) do
    case Plug.Conn.get_session(conn, :persona_id) do
      nil -> false
      persona_id when is_binary(persona_id) -> true
    end
  end
end
