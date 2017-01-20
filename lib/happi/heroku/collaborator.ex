defmodule Happi.Heroku.Collaborator do
  @moduledoc """
  Heroku app collaborator.
  """
  
  alias Happi.Heroku.{Ref, User}
  use Napper.Resource

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
    created_at: String.t,
    updated_at: String.t
  }
end

defimpl Napper.Endpoint, for: Happi.Heroku.Collaborator do
  def under_master_resource?(_), do: true
  def endpoint_url(_), do: "/collaborators"
end
