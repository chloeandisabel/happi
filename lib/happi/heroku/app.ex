defmodule Happi.Heroku.App do
  
  @moduledoc """
  Heroku Application.
  """

  alias Happi.Heroku.{Ref, User}

  @derive [Poison.Encoder]

  defstruct id: "",
    name: "app",
    buildpack_provided_description: "",
    build_stack: %Ref{},
    git_url: "",
    maintenance: false,
    owner: %User{},
    region: %Ref{},
    repo_size: 0,
    slug_size: 0,
    space: %Ref{},
    stack: %Ref{},
    web_url: "",
    released_at: nil,
    archived_at: nil,
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    name: String.t,
    buildpack_provided_description: String.t,
    build_stack: Ref.t,
    git_url: String.t,
    maintenance: false,
    owner: User.t,
    region: Ref.t,
    repo_size: integer,
    slug_size: integer,
    space: Ref.t,
    stack: Ref.t,
    web_url: String.t,
    released_at: String.t,      # TODO datetime
    archived_at: String.t,      # TODO datetime
    created_at: String.t,       # TODO datetime
    updated_at: String.t        # TODO datetime
  }
end

defimpl Happi.Endpoint, for: Happi.Heroku.App do
  def endpoint_url(_), do: "/apps"
  def app?(_), do: false
end
