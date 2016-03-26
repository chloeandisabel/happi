defprotocol Happi.Endpoint do

  @moduledoc """
  This protocol defines two methods that together determine the URL for a
  resource.
  """

  @type t :: Happi.Endpoint.t

  @doc """
  Returns `true` if the endpoint's URL is under "/apps/<app-id>".
  """
  @spec app?(t) :: boolean
  def app?(struct)

  @doc """
  Returns the endpoint URL. If `app?` returns `true` then the full URL will
  be "/apps/<app-id>/<endpoint-url>".
  """
  @spec endpoint_url(t) :: String.t
  def endpoint_url(struct)
end
