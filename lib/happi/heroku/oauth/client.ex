defmodule Happi.Heroku.OAuth.Client do
  use Napper.Resource

  defstruct id: "",
            name: "",
            redirect_uri: ""

  @type t :: %__MODULE__{
          id: String.t(),
          name: String.t(),
          redirect_uri: String.t()
        }
end

defimpl Napper.Endpoint, for: Happi.Heroku.Oauth.Client do
  def under_master_resource?(_), do: false
  def endpoint_url(_), do: "/oauth/clients"
end
