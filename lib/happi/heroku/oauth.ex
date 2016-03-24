defmodule Happi.Heroku.OAuth do
  
  @moduledoc """
  Heroku OAuth authorization.
  """
  
  @derive [Poison.Encoder]

  defstruct id: "",
    access_token: %Happi.Heroku.OAuth.Token{},
    client: %Happi.Heroku.OAuth.Client{},
    grant: %Happi.Heroku.OAuth.Grant{},
    refresh_token: %Happi.Heroku.OAuth.Token{},
    scope: [],
    user: %Happi.Heroku.User{},
    created_at: nil,
    updated_at: nil

  def list(client) do
    client
    |> Happi.API.get("/oauth/authorizations")
    |> Poison.decode!(as: [%Happi.Heroku.OAuth{}])
  end

  def get(client, oauth_authorization_id) do
    client
    |> Happi.API.get("/oauth/authorizations/#{oauth_authorization_id}")
    |> Poison.decode!(as: %Happi.Heroku.OAuth{})
  end

  def create(client, scopes, options) do
    oauth_client_id = Keyword.get(options, :client, nil)
    description = Keyword.get(options, :description, nil)
    expires_in = Keyword.get(options, :expires_in, nil)

    client
    |> Happi.API.post("/oauth/authorizations",
                      Poison.encode!(%{scope: scopes,
                                       client: oauth_client_id,
                                       description: description,
                                       expires_in: expires_in}))
    |> Poison.decode!(as: %Happi.Heroku.OAuth{})
  end

  def regenerate(client, oauth_authorization_id) do
    client
    |> Happi.API.post("/oauth/authorizations/#{oauth_authorization_id}/actions/regenerate-tokens")
    |> Poison.decode!(as: %Happi.Heroku.OAuth{})
  end

  def delete(client, oauth_authorization_id) do
    client
    |> Happi.API.delete("/oauth/authorizations/#{oauth_authorization_id}")
    |> Poison.decode!(as: %Happi.Heroku.OAuth{})
  end
end
