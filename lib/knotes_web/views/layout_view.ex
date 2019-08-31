defmodule KnotesWeb.LayoutView do
  use KnotesWeb, :view

  def signed_in?(conn) do
    case Plug.Conn.get_session(conn, :persona_id) do
      nil -> false
      _persona_id -> true
    end
  end
end
