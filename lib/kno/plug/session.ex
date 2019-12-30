defmodule Kno.Plug.Session do
  @behaviour Plug

  @impl Plug
  def init(options) do
    Kno.Config.init(options)
  end

  @impl Plug
  def call(conn, config) do
    conn = Plug.Conn.fetch_session(conn)

    case conn.request_path do
      "/session/new" ->
        new_session(conn, config)

      "/session/terminate" ->
        terminate_session(conn, config)

      _ ->
        session = Plug.Conn.get_session(conn)

        conn
        |> Plug.Conn.put_private(:kno_config, config)
        |> Plug.Conn.put_private(:kno_persona_id, Map.get(session, "kno_persona_id"))
    end
  end

  defp new_session(conn, config) do
    %Kno.Config{success_redirect: success_redirect} = config
    kno_token = fetch_kno_token(conn)
    persona_id = authenticate(kno_token, config)

    conn
    |> Plug.Conn.put_session("kno_persona_id", persona_id)
    |> redirect(success_redirect)
  end

  defp fetch_kno_token(conn) do
    case conn.params do
      %{"knoToken" => kno_token} ->
        kno_token

      _ ->
        raise Kno.RequestError
    end
  end

  defp authenticate(kno_token, config) do
    case Kno.API.authenticate(kno_token, config) do
      {:ok, %{id: persona_id}} ->
        persona_id

      {:error, exception} ->
        raise exception
    end
  end

  defp terminate_session(conn, _config) do
    conn
    |> Plug.Conn.clear_session()
    |> redirect("/")
  end

  defp redirect(conn, path) do
    conn
    |> Plug.Conn.halt()
    |> Plug.Conn.resp(303, "")
    |> Plug.Conn.put_resp_header("location", path)
  end
end
