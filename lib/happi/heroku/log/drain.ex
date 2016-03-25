defmodule Happi.Heroku.Log.Drain do
  
  @moduledoc """
  Heroku log drain.
  """
  
  alias Happi.Heroku.Ref

  @derive [Poison.Encoder]

  defstruct id: "",
    token: "",
    url: "",
    addon: %Ref{},
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    token: String.t,
    url: String.t,
    addon: Ref.t,
    created_at: String.t,       # TODO datetime
    updated_at: String.t        # TODO datetime
  }

  @spec list(Happi.t) :: [t]
  def list(client) do
    client
    |> Happi.API.get("/apps/#{client.app.url}/log-drains")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @spec get(Happi.t, String.t) :: t
  def get(client, id_or_url) do
    client
    |> Happi.API.get("/apps/#{client.app.url}/log-drains/#{id_or_url}")
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec create(Happi.t, String.t) :: t
  def create(client, url) do
    client
    |> Happi.API.post("/apps/#{client.app.url}/log-drains",
                      Poison.encode!(%{url: url}))
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec delete(Happi.t, String.t) :: t
  def delete(client, id_or_url) do
    client
    |> Happi.API.delete("/apps/#{client.app.url}/log-drains/#{id_or_url}")
    |> Poison.decode!(as: %__MODULE__{})
  end
end
