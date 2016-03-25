defmodule Happi.Heroku.Buildpack do
  
  @moduledoc """
  Heroku buildpack.
  """
  
  defstruct url: "",
    name: "",
    ordinal: 0                  # only used with buildpack installations

  @type t :: %__MODULE__{
    url: String.t,
    name: String.t,
    ordinal: integer
  }

  @spec list(Happi.t) :: [t]
  def list(client) do
    client
    |> Happi.API.get("/apps/#{client.app.id}/buildpack-installations")
    |> Poison.decode!(as: %__MODULE__{})
  end

  @doc """
  `identifiers` can be names, URLs, or URNs.
  """
  @spec update(Happi.t, [String.t]) :: [t]
  def update(client, identifiers) do
    request = %{updates: Enum.map(identifiers, fn(url) -> %{buildpack: url} end)}
    client
    |> Happi.API.put("/apps/#{client.app.id}/buildpack-installations", request)
    |> Poison.decode!(as: [%__MODULE__{}])
  end

end
