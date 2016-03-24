defmodule Happi.Heroku.Formation do
  
  @moduledoc """
  Heroku formation.
  """
  
  @derive [Poison.Encoder]

  defstruct id: "",
    app: %Happi.Heroku.Ref{},
    command: "",
    quantity: 1,
    size: "",
    type: "",
    created_at: nil,
    updated_at: nil

  def list(client) do
    client
    |> Happi.API.get("/apps/#{client.app.name}/formation/")
    |> Poison.decode!(as: [%Happi.Heroku.Formation{}])
  end

  def get(client, id_or_type) do
    client
    |> Happi.API.get("/apps/#{client.app.name}/formation/#{id_or_type}")
    |> Poison.decode!(as: %Happi.Heroku.Formation{})
  end

  def update(client, formations) when is_list(formations) do
    client
    |> Happi.API.patch("/apps/#{client.app.id}/formation",
                       Poison.encode!(formations, as: [%Happi.Heroku.Formation{}]))
    |> Poison.decode!(as: [%Happi.Heroku.Formation{}])
  end

  def update(client, formation) do
    client
    |> Happi.API.patch("/apps/#{client.app.id}/formation/#{formation.id}",
                       Poison.encode!(formation))
    |> Poison.decode!(as: %Happi.Heroku.Formation{})
  end
end
