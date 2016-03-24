defmodule Happi.Heroku.Build do
  
  @moduledoc """
  Heroku build structure.
  """
  
  @derive [Poison.Encoder]
  
  defstruct id: "",
    status: "",
    app: %Happi.Heroku.IdRef{},
    buildpacks: [%Happi.Heroku.Buildpack{}],
    output_stream_url: "",
    source_blob: %Happi.Heroku.SourceBlob{},
    slug: %Happi.Heroku.IdRef{},
    status: "",
    user: %Happi.Heroku.User{},
    created_at: nil,
    updated_at: nil

  def list(client) do
    client
    |> Happi.API.get(client, "/apps/#{client.app.id}/builds")
    |> Poison.decode!(as: [%Happi.Heroku.Build{}])
  end

  def get(client, build_id) do
    client
    |> Happi.API.get(client, "/apps/#{client.app.id}/builds/#{build_id}")
    |> Poison.decode!(as: %Happi.Heroku.Build{})
  end
end
