defmodule KnotesWeb.SessionController do
  use KnotesWeb, :controller

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
    url = "https://api.trykno.app/v0/pass"
    body = Jason.encode!(%{"token" => token})
    basic_auth = Enum.join(["alpha", "kno_local_site_token", "kno_local_api_key"], ".") <> ":"

    headers = [
      {"authorization", "Basic " <> Base.encode64(basic_auth)},
      {"content-type", "application/json"},
      {"accept", "application/json"}
    ]

    case HTTPoison.post(url, body, headers) do
      {:ok, %{status_code: 200, body: body}} ->
        %{"persona" => %{"id" => persona_id}} = Jason.decode!(body)

        {:ok, persona_id}

      _reply ->
        {:error, :unauthorized}
    end
  end
end
