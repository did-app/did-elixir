defmodule Kno.Config do
  @moduledoc false
  @enforce_keys [
    :api_host,
    :api_token,
    :cdn_host,
    :site_token,
    :success_redirect
  ]
  defstruct @enforce_keys

  @api_host "https://api.trykno.app"
  @cdn_host "https://trykno.app"
  @api_token "API_AAAAAgDOxdmUqKpE9rw82Jj0Y6DM"
  @site_token "site_UITYJw8kQJilzVnux5VOPw"

  def init(options) do
    api_host = Keyword.get(options, :api_host, @api_host)
    api_token = Keyword.get(options, :api_token, @api_token)
    cdn_host = Keyword.get(options, :cdn_host, @cdn_host)
    site_token = Keyword.get(options, :site_token, @site_token)
    success_redirect = Keyword.fetch!(options, :success_redirect)

    %__MODULE__{
      api_host: api_host,
      api_token: api_token,
      cdn_host: cdn_host,
      site_token: site_token,
      success_redirect: success_redirect
    }
  end
end
