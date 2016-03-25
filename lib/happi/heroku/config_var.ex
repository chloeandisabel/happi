defmodule Happi.Heroku.ConfigVar do
  
  @moduledoc """
  Heroku config variables, represented as Maps.
  """
  
  @spec get(Happi.t) :: Map.t
  def get(client) do
    client
    |> Happi.get("/apps/#{client.app.id}/config-vars")
    |> Poison.decode!
  end
  
  @spec update(Happi.t, Map.t) :: Map.t
  def update(client, config_vars) do
    client
    |> Happi.patch("/apps/#{client.app.id}/config-vars", config_vars)
    |> Poison.decode!
  end
end
