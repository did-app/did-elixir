defmodule Kno.API do
  @moduledoc false

  @version "/v0"
  @authenticate_path @version <> "/authenticate"

  def authenticate(kno_token, config) do
    %Kno.Config{api_token: api_token, api_host: api_host} = config
    url = api_host <> @authenticate_path

    headers = [
      {"authorization", "Basic #{Base.encode64(api_token <> ":")}"},
      {"content-type", "application/json"}
    ]

    body = Jason.encode!(%{token: kno_token})

    case HTTPoison.post!(url, body, headers) do
      %{status_code: 200, body: response_body} ->
        %{"persona" => %{"id" => persona_id}} = Jason.decode!(response_body)
        {:ok, %{id: persona_id}}
    end
  end
end
