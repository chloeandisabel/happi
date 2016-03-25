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

  @doc """
  Return a list containing all of your apps.
  """
  @spec list(Happi.t) :: [t]
  def list(client) do
    client
    |> Happi.API.get("/apps")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @doc """
  Returns the client's app. If you want to get another app, create another
  client.
  """
  @spec get(Happi.t) :: t
  def get(client) do
    client.app
  end      

  @doc """
  Only used by Happi to grab the app initially. Everybody else should call
  `get/1`.

  `client` will contain base_url and key but, hopefully unsurprisingly, no
  app.
  """
  @spec initial_get(Happi.t, String.t) :: t
  def initial_get(client, app_name_or_id) do
    client
    |> Happi.API.get("/apps/#{app_name_or_id}")
    |> Poison.decode!(as: %__MODULE__{})
  end
end
