defmodule Happi.Heroku.Log.Drain do
  
  @moduledoc """
  Heroku log drain.
  """
  
  alias Happi.Heroku.Ref

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
    created_at: String.t,       # TODO datetime
    updated_at: String.t        # TODO datetime
  }
end

defimpl Happi.Endpoint, for: Happi.Heroku.Drain do
  def endpoint_url(_), do: "/log-drains"
  def app?(_), do: true
end
