defmodule Happi.Heroku.Log.Drain do
  @moduledoc """
  Heroku log drain.
  """
  
  alias Happi.Heroku.Ref
  use Happi.Resource

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

defimpl Happi.Endpoint, for: Happi.Heroku.Log.Drain do
  def endpoint_url(_), do: "/log-drains"
  def app_resource?(_), do: true
end
