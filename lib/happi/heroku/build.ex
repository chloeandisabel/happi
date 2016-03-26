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
end

defimpl Happi.Endpoint, for: Happi.Heroku.Build do
  def endpoint_url(_), do: "/builds"
  def app?(_), do: true
end
