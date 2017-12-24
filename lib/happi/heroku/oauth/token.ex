defmodule Happi.Heroku.OAuth.Token do
  use Napper.Resource

  defstruct id: "",
            token: "",
            expires_in: 0

  @type t :: %__MODULE__{
          id: String.t(),
          token: String.t(),
          expires_in: integer
        }
end

defimpl Napper.Endpoint, for: Happi.Heroku.Oauth.Token do
  def under_master_resource?(_), do: false
  def endpoint_url(_), do: "/oauth/tokens"
end
