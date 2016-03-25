defmodule Happi.Heroku.Build do
  
  @moduledoc """
  Heroku build structure.
  """
  
  alias Happi.Heroku.{IdRef, Buildpack, SourceBlob, User}

  @derive [Poison.Encoder]
  
  defstruct id: "",
    status: "",
    app: %IdRef{},
    buildpacks: [%Buildpack{}],
    output_stream_url: "",
    source_blob: %SourceBlob{},
    slug: %IdRef{},
    status: "",
    user: %User{},
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    status: String.t,
    app: IdRef.t,
    buildpacks: [Buildpack.t],
    output_stream_url: String.t,
    source_blob: SourceBlob.t,
    slug: IdRef.t,
    status: String.t,
    user: User.t,
    created_at: String.t,       # TODO datetime
    updated_at: String.t        # TODO datetime
  }

  @spec list(Happi.t) :: [t]
  def list(client) do
    client
    |> Happi.API.get(client, "/apps/#{client.app.id}/builds")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @spec get(Happi.t, String.t) :: t
  def get(client, build_id) do
    client
    |> Happi.API.get(client, "/apps/#{client.app.id}/builds/#{build_id}")
    |> Poison.decode!(as: %__MODULE__{})
  end
end
