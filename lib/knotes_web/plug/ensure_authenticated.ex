defmodule KnotesWeb.Plug.EnsureAuthenticated do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller

  alias KnotesWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :persona_id) do
      nil ->
        conn
        |> put_flash(:error, "You don't have permission to access that page")
        |> redirect(to: Routes.page_path(conn, :index))
        |> halt()

      persona_id when is_binary(persona_id) ->
        conn
    end
  end
end
