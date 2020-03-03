defmodule MyAppWeb.SessionController do
  use MyAppWeb, :controller

  def authenticate(conn, _params) do
    conn
    |> redirect(external: OpenIDConnect.authorization_uri(:did))
  end

  def callback(conn, %{"code" => code}) do
    {:ok, tokens} = OpenIDConnect.fetch_tokens(:did, %{code: code})
    {:ok, claims} = OpenIDConnect.verify(:did, tokens["id_token"])
    user_id = claims["sub"]

    conn
    |> put_session(:user_id, user_id)
    |> redirect(to: "/")
  end
end
