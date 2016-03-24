defmodule Happi.Heroku.Dyno do
  
  @moduledoc """
  Heroku Dyno.
  """
  
  @derive [Poison.Encoder]
  
  defstruct id: "",
    attach_url: nil,
    command: "",
    name: "",
    app: %Happi.Heroku.Ref{},
    release: %Happi.Heroku.Release{},
    size: "",
    state: "",
    type: "",
    created_at: nil,
    updated_at: nil

  def list(client) do
    client
    |> Happi.API.get("/apps/#{client.app.id}/dynos")
    |> Poison.decode!(as: [%Happi.Heroku.Dyno{}])
  end

  def get(client, id_or_name) do
    client
    |> Happi.API.get("/apps/#{client.app.id}/dynos/#{id_or_name}")
    |> Poison.decode!(as: %Happi.Heroku.Dyno{})
  end

  def create(client, command, options \\ []) do
    attach = Keyword.get(options, :attach, true)
    env = Keyword.get(options, :env, %{})
    size = Keyword.get(options, :size, "standard-1X")
    client
    |> Happi.API.post("/apps/#{client.app.name}/dynos",
                      Poison.encode(%{command: command, attach: attach,
                                      env: env, size: size}))
    |> Poison.decode!(as: %Happi.Heroku.Dyno{})
  end

  def restart(client, id_or_name) do
    client
    |> Happi.API.delete("/apps/#{client.app.name}/dynos/#{id_or_name}")
  end

  def restart_all(client) do
    client
    |> Happi.API.delete("/apps/#{client.app.name}/dynos")
  end
end
