defmodule Happi.Heroku.Formation do
  
  @moduledoc """
  Heroku formation.
  """
  
  alias Happi.Heroku.Ref

  @derive [Poison.Encoder]

  defstruct id: "",
    app: %Ref{},
    command: "",
    quantity: 1,
    size: "",
    type: "",
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    app: Ref.t,
    command: String.t,
    quantity: integer,
    size: String.t,
    type: String.t,
    created_at: String.t,
    updated_at: String.t
  }
end

defimpl Happi.Endpoint, for: Happi.Heroku.Formation do
  def endpoint_url(_), do: "/formation"
  def app?(_), do: true
end
