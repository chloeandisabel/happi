defprotocol Happi.Endpoint do

  @moduledoc """
  This protocol defines two methods that together determine the URL for a
  resource.
  """

  @type t :: Happi.Endpoint.t

  @doc """
  Returns `true` if the endpoint's URL is under "/apps/<app-id>". That is,
  when generating a URL for this resource the full URL will be prefixed by
  "/apps/<app-id>" if this function returns `true`.
  """
  @spec app?(t) :: boolean
  def app?(struct)

  @doc """
  Returns the endpoint URL for all get/post/etc. requests to the API for the
  resource that implements this protocol.

  If `app?` returns `true` then the full URL will be
  "/apps/<app-id><endpoint-url>", where app-id is the `app` value stored in
  the `Happi` client struct. Note that there is no slash after the app-id,
  so your endpoint URL should always begin with a slash.
  """
  @spec endpoint_url(t) :: String.t
  def endpoint_url(struct)
end
