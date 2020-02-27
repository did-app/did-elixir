defmodule Plugeroo do
  import Plug.Conn

  def init(options) do
    # initialize options
    options
  end

  def call(conn = %{request_path: "/sign_in", method: "GET"}, _opts) do
    IO.inspect(conn)
    redirect_uri = ""

    authorization_url =
      "http://localhost:7000/oidc/authorize?client_id=http://localhost:4001&redirect_uri=http://localhost:4001/callback&scope=openid&response_type=code&response_mode=form_post&code_challenge=1234&state=state1234"

    conn
    |> put_resp_header("location", authorization_url)
    |> send_resp(303, "")
  end

  def call(conn = %{request_path: "/callback", method: "POST"}, _opts) do
    IO.inspect(conn)
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    %{"code" => code, "state" => "state" <> code_verifier} = URI.decode_query(body)

    token_request =
      "code=#{code}&grant_type=authorization_code&redirect_uri=http://localhost:4001/callback&code_verifier=#{
        code_verifier
      }&client_id=http://localhost:4001"

    :httpc.request(
      :post,
      {'http://localhost:7000/oidc/token', [], 'x-www-form-urlencoded',
       String.to_charlist(token_request)},
      [],
      []
    )
    |> IO.inspect()

    # redirect_uri = ""
    #
    # authorization_url =
    #   "http://localhost:7000/oidc/authorize?client_id=http://localhost:4001&redirect_uri=http://localhost:4001/callback&scope=openid&response_type=code&response_mode=form_post"
    #
    # conn
    # |> put_resp_header("location", authorization_url)
    # |> send_resp(303, "")
  end

  def call(conn = %{request_path: "/", method: "GET"}, _opts) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, """
    <a href="/sign_in">Sign in</a>
    """)
  end
end
