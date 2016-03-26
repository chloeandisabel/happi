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
end

defimpl Happi.Endpoint, for: Happi.Heroku.Collaborator do
  def endpoint_url(_), do: "/collaborators"
  def app?(_), do: true
end
