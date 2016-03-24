defmodule Happi.Heroku.Domain do
  
  @moduledoc """
  Heroku domain.
  """
  
  @derive [Poison.Encoder]

  defstruct id: "",
    app: %Happi.Heroku.Ref{},
    cname: "",
    hostname: "",
    kind: "",
    created_at: nil,
    updated_at: nil

  def list(client) do
    client
    |> Happi.API.post("/apps/#{client.app.id}/domains")
    |> Poison.decode!([%Happi.Heroku.Domain{}])
  end

  def get(client, id_or_hostname) do
    client
    |> Happi.API.post("/apps/#{client.app.id}/domains/#{id_or_hostname}")
    |> Poison.decode!(%Happi.Heroku.Domain{})
  end

  def create(client, hostname) do
    client
    |> Happi.API.post("/apps/#{client.app.id}/domains",
                      Poison.encode!(%{hostname: hostname}))
    |> Poison.decode!(%Happi.Heroku.Domain{})
  end

  def delete(client, id_or_hostname) do
    client
    |> Happi.API.delete("/apps/#{client.app.id}/domains/#{id_or_hostname}")
    |> Poison.decode!(%Happi.Heroku.Domain{})
  end
end
