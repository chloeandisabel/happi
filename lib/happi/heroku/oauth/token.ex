defmodule Happi.Heroku.OAuth.Token do
  use Happi.Resource
  
  defstruct id: "",
    token: "",
    expires_in: 0

  @type t :: %__MODULE__{
    id: String.t,
    token: String.t,
    expires_in: integer
  }
end

defimpl Happi.Endpoint, for: Happi.Heroku.Oauth.Token do
  def endpoint_url(_), do: "/oauth/tokens"
  def app?(_), do: false
end
