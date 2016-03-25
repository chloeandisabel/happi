defmodule Happi.Heroku.Collaborator do
  
  @moduledoc """
  Heroku app collaborator.
  """
  
  alias Happi.Heroku.{Ref, User}

  @derive [Poison.Encoder]

  defstruct id: "",
    app: %Ref{},
    user: %User{},
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    app: Ref.t,
    user: User.t,
    created_at: String.t,       # TODO datetime
    updated_at: String.t        # TODO datetime
  }

  @spec list(Happi.t) :: [t]
  def list(client) do
    client
    |> Happi.API.post("/apps/#{client.app.id}/collaborators")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @spec get(Happi.t, String.t) :: t
  def get(client, email_or_id) do
    client
    |> Happi.API.post("/apps/#{client.app.id}/collaborators/#{email_or_id}")
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec create(Happi.t, Happi.Heroku.User.t, boolean) :: t
  def create(client, user, silent \\ false) do
    client
    |> Happi.API.post("/apps/#{client.app.id}/collaborators",
                      Poison.encode!(%{user: user, silent: silent}))
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec delete(Happi.t, String.t) :: t
  def delete(client, email_or_id) do
    client
    |> Happi.API.delete("/apps/#{client.app.id}/collaborators/#{email_or_id}")
    |> Poison.decode!(as: %__MODULE__{})
  end
end
