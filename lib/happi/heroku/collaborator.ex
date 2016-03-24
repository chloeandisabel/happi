defmodule Happi.Heroku.Collaborator do
  
  @moduledoc """
  Heroku app collaborator.
  """
  
  @derive [Poison.Encoder]

  defstruct id: "",
    app: %Happi.Heroku.Ref{},
    user: %Happi.Heroku.User{},
    created_at: nil,
    updated_at: nil

  @spec list(Happi.t) :: [%Happi.Heroku.Collaborator{}]
  def list(client) do
    client
    |> Happi.API.post("/apps/#{client.app.id}/collaborators")
    |> Poison.decode!(as: [%Happi.Heroku.Collaborator{}])
  end

  @spec get(Happi.t, String.t) :: %Happi.Heroku.Collaborator{}
  def get(client, email_or_id) do
    client
    |> Happi.API.post("/apps/#{client.app.id}/collaborators/#{email_or_id}")
    |> Poison.decode!(as: %Happi.Heroku.Collaborator{})
  end

  @spec create(Happi.t, Happi.Heroku.User.t, boolean) :: %Happi.Heroku.Collaborator{}
  def create(client, user, silent \\ false) do
    client
    |> Happi.API.post("/apps/#{client.app.id}/collaborators",
                      Poison.encode!(%{user: user, silent: silent}))
    |> Poison.decode!(as: %Happi.Heroku.Collaborator{})
  end

  @spec delete(Happi.t, String.t) :: %Happi.Heroku.Collaborator{}
  def delete(client, email_or_id) do
    client
    |> Happi.API.delete("/apps/#{client.app.id}/collaborators/#{email_or_id}")
    |> Poison.decode!(as: %Happi.Heroku.Collaborator{})
  end
end
