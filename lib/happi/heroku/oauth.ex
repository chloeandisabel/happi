defmodule Happi.Heroku.OAuth do
  
  @moduledoc """
  Heroku OAuth authorization.
  """
  
  alias Happi.Heroku.User
  alias Happi.Heroku.OAuth.{Client, Grant, Token}

  @derive [Poison.Encoder]

  defstruct id: "",
    access_token: %Token{},
    client: %Client{},
    grant: %Grant{},
    refresh_token: %Token{},
    scope: [],
    user: %User{},
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    access_token: Token.t,
    client: Client.t,
    grant: Grant.t,
    refresh_token: Token.t,
    scope: [String.t],
    user: User.t,
    created_at: String.t,
    updated_at: String.t
  }

  @spec regenerate(Happi.t, String.t) :: t
  def regenerate(client, oauth_authorization_id) do
    client
    |> Happi.API.post("/oauth/authorizations/#{oauth_authorization_id}/actions/regenerate-tokens")
    |> Poison.decode!(as: %__MODULE__{})
  end
end

defimpl Happi.Endpoint, for: Happi.Heroku.OAuth do
  def endpoint_url(_), do: "/oauth/authorizations"
  def app?(_), do: false
end
