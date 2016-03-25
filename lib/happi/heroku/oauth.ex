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
    created_at: String.t,       # TODO datetime
    updated_at: String.t        # TODO datetime
  }

  @spec list(Happi.t) :: [t]
  def list(client) do
    client
    |> Happi.API.get("/oauth/authorizations")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @spec get(Happi.t, String.t) :: t
  def get(client, oauth_authorization_id) do
    client
    |> Happi.API.get("/oauth/authorizations/#{oauth_authorization_id}")
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec create(Happi.t, Map.t) :: t
  def create(client, params) do
    client
    |> Happi.API.post("/oauth/authorizations", Poison.encode!(params))
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec regenerate(Happi.t, String.t) :: t
  def regenerate(client, oauth_authorization_id) do
    client
    |> Happi.API.post("/oauth/authorizations/#{oauth_authorization_id}/actions/regenerate-tokens")
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec delete(Happi.t, String.t) :: t
  def delete(client, oauth_authorization_id) do
    client
    |> Happi.API.delete("/oauth/authorizations/#{oauth_authorization_id}")
    |> Poison.decode!(as: %__MODULE__{})
  end
end
