defmodule Happi.Heroku.Log.Drain do
  @moduledoc """
  Heroku log drain.
  """
  
  alias Happi.Heroku.Ref
  use Napper.Resource

  @derive [Poison.Encoder]

  defstruct id: "",
    token: "",
    url: "",
    addon: %Ref{},
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    token: String.t,
    url: String.t,
    addon: Ref.t,
    created_at: String.t,
    updated_at: String.t
  }
end

defimpl Napper.Endpoint, for: Happi.Heroku.Log.Drain do
  def under_master_resource?(_), do: true
  def endpoint_url(_), do: "/log-drains"
end
