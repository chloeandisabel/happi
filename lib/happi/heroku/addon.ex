defmodule Happi.Heroku.Addon do
  
  @moduledoc """
  Heroku application add-on. See `Happi.Heroku.Addon.Attachment`.
  """
  
  @derive [Poison.Encoder]
  
  defstruct id: "",
    name: "",
    app: %Happi.Heroku.Ref{},
    addon_service: %Happi.Heroku.Addon.Service{},
    config_vars: [],
    plan: %Happi.Heroku.Ref{},
    provider_id: "",
    web_url: "",
    created_at: nil,
    updated_at: nil

  def list(client) do
    client
    |> Happi.API.get("/addons")
    |> Poison.decode!(as: [%Happi.Heroku.Addon{}])
  end

  def get(client, name_or_id) do
    client
    |> Happi.API.get("/addons/#{name_or_id}")
    |> Poison.decode!(as: %Happi.Heroku.Addon{})
  end

  @doc """
  Returns a list of addons for the current app.
  """
  def get(client) do
    client
    |> Happi.API.get("/apps/#{client.app.id}/addons")
    |> Poison.decode!(as: [%Happi.Heroku.Addon{}])
  end

  @spec create(Happi.t, %Happi.Heroku.Addon{}) :: %Happi.Heroku.Addon{}
  def create(client, addon) do
    client
    |> Happi.API.post("/apps/#{client.app.id}/addons",
                      Poison.encode!(addon))
    |> Poison.decode!(as: %Happi.Heroku.Addon{})
  end

  @spec update(Happi.t, %Happi.Heroku.Addon{}) :: %Happi.Heroku.Addon{}
  def update(client, addon) do
    client
    |> Happi.API.patch("/apps/#{client.app.id}/addons/#{addon.id}",
                       Poison.encode!(addon))
    |> Poison.decode!(as: %Happi.Heroku.Addon{})
  end

  def delete(client, addon) do
    client
    |> Happi.API.delete("/apps/#{client.app.id}/addons/#{addon.id}")
    |> Poison.decode!(as: %Happi.Heroku.Addon{})
  end
end
