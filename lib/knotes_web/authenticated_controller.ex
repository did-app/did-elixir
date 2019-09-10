defmodule KnotesWeb.AuthenticatedController do
  @moduledoc """
  Use this module in a controller to have the authenticated `persona_id` passed
  to the action as the third argument.

  ## Usage example

  defmodule KnotesWeb.MyController do
    use KnotesWeb, :controller
    use KnotesWeb.AuthenticatedController

    plug(KnotesWeb.Plug.EnsureAuthenticated)

    def index(conn, params, persona_id) do
      # ...
    end
  end
  """

  defmacro __using__(_opts \\ []) do
    quote do
      def action(conn, _) do
        persona_id = get_session(conn, :persona_id)
        args = [conn, conn.params, persona_id]

        apply(__MODULE__, action_name(conn), args)
      end
    end
  end
end
