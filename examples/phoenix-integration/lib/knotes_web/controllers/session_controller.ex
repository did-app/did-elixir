defmodule KnotesWeb.SessionController do
  use KnotesWeb, :controller
  alias Knotes.Authentication.Kno

  def create(conn, %{"knoToken" => token}) do
    case verify_token(token) do
      {:ok, persona_id} ->
        conn
        |> put_session(:persona_id, persona_id)
        |> put_flash(:info, "Signed in successfully.")
        |> redirect(to: "/")

      {:error, :unauthorized} ->
        conn
        |> put_status(403)
        |> put_view(KnotesWeb.ErrorView)
        |> render(:"403")
    end
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: "/")
  end

  defp verify_token(token) do
    client = Kno.client("kno_local_site_token", "kno_local_api_key")

    case Kno.verify_token(client, token) do
      {:ok, %{status: 200, body: %{"persona" => %{"id" => persona_id}}}} ->
        {:ok, persona_id}

      _reply ->
        {:error, :unauthorized}
    end
  end
end
