defmodule Happi.Heroku.Formation do
  
  @moduledoc """
  Heroku formation.
  """
  
  alias Happi.Heroku.Ref

  @derive [Poison.Encoder]

  defstruct id: "",
    app: %Ref{},
    command: "",
    quantity: 1,
    size: "",
    type: "",
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    app: Ref.t,
    command: String.t,
    quantity: integer,
    size: String.t,
    type: String.t,
    created_at: String.t,
    updated_at: String.t
  }

  @spec list(Happi.t) :: [t]
  def list(client) do
    client
    |> Happi.API.get("/apps/#{client.app.name}/formation/")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @spec get(Happi.t, String.t) :: t
  def get(client, id_or_type) do
    client
    |> Happi.API.get("/apps/#{client.app.name}/formation/#{id_or_type}")
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec update(Happi.t, [t]) :: [t]
  def update(client, formations) when is_list(formations) do
    client
    |> Happi.API.patch("/apps/#{client.app.id}/formation",
                       Poison.encode!(formations, as: [%__MODULE__{}]))
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @spec update(Happi.t, t) :: t
  def update(client, formation) do
    client
    |> Happi.API.patch("/apps/#{client.app.id}/formation/#{formation.id}",
                       Poison.encode!(formation))
    |> Poison.decode!(as: %__MODULE__{})
  end
end
