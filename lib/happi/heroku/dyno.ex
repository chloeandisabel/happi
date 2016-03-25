defmodule Happi.Heroku.Dyno do
  
  @moduledoc """
  Heroku Dyno.
  """
  
  alias Happi.Heroku.{Ref, Release}

  @derive [Poison.Encoder]
  
  defstruct id: "",
    attach_url: nil,
    command: "",
    name: "",
    app: %Ref{},
    release: %Release{},
    size: "",
    state: "",
    type: "",
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    attach_url: String.t,
    command: String.t,
    name: String.t,
    app: Ref.t,
    release: Release.t,
    size: String.t,
    state: String.t,
    type: String.t,
    created_at: String.t,       # TODO datetime
    updated_at: String.t        # TODO datetime
  }

  @spec list(Happi.t) :: [t]
  def list(client) do
    client
    |> Happi.API.get("/apps/#{client.app.id}/dynos")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @spec get(Happi.t, String.t) :: t
  def get(client, id_or_name) do
    client
    |> Happi.API.get("/apps/#{client.app.id}/dynos/#{id_or_name}")
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec create(Happi.t, String.t) :: t
  def create(client, command, options \\ []) do
    attach = Keyword.get(options, :attach, true)
    env = Keyword.get(options, :env, %{})
    size = Keyword.get(options, :size, "standard-1X")
    client
    |> Happi.API.post("/apps/#{client.app.name}/dynos",
                      Poison.encode(%{command: command, attach: attach,
                                      env: env, size: size}))
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec restart(Happi.t, String.t) :: :ok
  def restart(client, id_or_name) do
    client
    |> Happi.API.delete("/apps/#{client.app.name}/dynos/#{id_or_name}")
    :ok                         # TODO handle error return codes
  end

  @spec restart_all(Happi.t) :: :ok
  def restart_all(client) do
    client
    |> Happi.API.delete("/apps/#{client.app.name}/dynos")
    :ok                         # TODO handle error return codes
  end
end
