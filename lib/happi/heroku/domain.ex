defmodule Happi.Heroku.Domain do
  
  @moduledoc """
  Heroku domain.
  """
  
  alias Happi.Heroku.Ref

  @derive [Poison.Encoder]

  defstruct id: "",
    app: %Ref{},
    cname: "",
    hostname: "",
    kind: "",
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    app: Ref.t,
    cname: String.t,
    hostname: String.t,
    kind: String.t,
    created_at: String.t,       # TODO datetime
    updated_at: String.t        # TODO datetime
  }

  @spec list(Happi.t) :: [t]
  def list(client) do
    client
    |> Happi.API.post("/apps/#{client.app.id}/domains")
    |> Poison.decode!([%__MODULE__{}])
  end

  @spec get(Happi.t, String.t) :: t
  def get(client, id_or_hostname) do
    client
    |> Happi.API.post("/apps/#{client.app.id}/domains/#{id_or_hostname}")
    |> Poison.decode!(%__MODULE__{})
  end

  @spec create(Happi.t, String.t) :: t
  def create(client, hostname) do
    client
    |> Happi.API.post("/apps/#{client.app.id}/domains",
                      Poison.encode!(%{hostname: hostname}))
    |> Poison.decode!(%__MODULE__{})
  end

  @spec delete(Happi.t, String.t) :: t
  def delete(client, id_or_hostname) do
    client
    |> Happi.API.delete("/apps/#{client.app.id}/domains/#{id_or_hostname}")
    |> Poison.decode!(%__MODULE__{})
  end
end
