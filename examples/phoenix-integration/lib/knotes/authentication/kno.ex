defmodule Knotes.Authentication.Kno do
  def client(kno_site_token, kno_api_key) do
    basic_auth = Enum.join(["alpha", kno_site_token, kno_api_key], ".") <> ":"

    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.trykno.app"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
         {"authorization", "Basic " <> Base.encode64(basic_auth)},
         {"accept", "application/json"},
         {"content-type", "application/json"}
       ]}
    ]

    Tesla.client(middleware)
  end

  def verify_token(client, token) do
    Tesla.post(client, "/v0/pass", %{"token" => token})
  end
end
