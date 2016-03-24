defmodule Happi.Heroku.Log.Drain do
  
  @moduledoc """
  Heroku log drain.
  """
  
  @derive [Poison.Encoder]

  defstruct id: "",
    token: "",
    url: "",
    addon: %Happi.Heroku.Ref{},
    created_at: nil,
    updated_at: nil

  def list(client) do
    client
    |> Happi.API.get("/apps/#{client.app.url}/log-drains")
    |> Poison.decode!(as: [%Happi.Heroku.Log.Drain{}])
  end

  def get(client, id_or_url) do
    client
    |> Happi.API.get("/apps/#{client.app.url}/log-drains/#{id_or_url}")
    |> Poison.decode!(as: %Happi.Heroku.Log.Drain{})
  end

  def create(client, url) do
    client
    |> Happi.API.post("/apps/#{client.app.url}/log-drains",
                      Poison.encode!(%{url: url}))
    |> Poison.decode!(as: %Happi.Heroku.Log.Drain{})
  end

  def delete(client, id_or_url) do
    client
    |> Happi.API.delete("/apps/#{client.app.url}/log-drains/#{id_or_url}")
    |> Poison.decode!(as: %Happi.Heroku.Log.Drain{})
  end
end
