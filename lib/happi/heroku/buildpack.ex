defmodule Happi.Heroku.Buildpack do
  
  @moduledoc """
  Heroku buildpack.
  """
  
  defstruct url: "",
    name: "",
    ordinal: 0                  # only used with buildpack installations

  def list(client) do
    client
    |> Happi.API.get("/apps/#{client.app.id}/buildpack-installations")
    |> Poison.decode!(as: %Happi.Heroku.Buildpack{})
  end

  @doc """
  `identifiers` can be names, URLs, or URNs.
  """
  def update(client, identifiers) do
    request = %{updates: Enum.map(identifiers, fn(url) -> %{buildpack: url} end)}
    client
    |> Happi.API.put("/apps/#{client.app.id}/buildpack-installations", request)
    |> Poison.decode!(as: %Happi.Heroku.Buildpack{})
  end

end
