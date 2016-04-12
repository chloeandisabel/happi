defmodule Happi.Heroku.OAuth.Client do
  use Happi.Resource
  
  defstruct id: "",
    name: "",
    redirect_uri: ""
  
  @type t :: %__MODULE__{
    id: String.t,
    name: String.t,
    redirect_uri: String.t
  }
end

defimpl Happi.Endpoint, for: Happi.Heroku.Oauth.Client do
  def endpoint_url(_), do: "/oauth/clients"
  def app?(_), do: false
end
