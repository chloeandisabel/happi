defmodule Happi.Heroku.Domain do
  @moduledoc """
  Heroku domain.
  """
  
  alias Happi.Heroku.Ref
  use Happi.Resource

  @derive [Poison.Encoder]

  defstruct id: "",
    app: %Ref{},
    cname: "",
    hostname: "",
    kind: "",
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    app: Ref.t,
    cname: String.t,
    hostname: String.t,
    kind: String.t,
    created_at: String.t,
    updated_at: String.t
  }
end

defimpl Happi.Endpoint, for: Happi.Heroku.Domain do
  def endpoint_url(_), do: "/domains"
  def app_resource?(_), do: true
end
