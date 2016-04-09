defmodule Happi.Heroku.Log.Session do
  
  @moduledoc """
  Heroku log drain.

  Only the `Happi.create` endpoint makes sense.
  """
  
  @derive [Poison.Encoder]

  defstruct id: "",
    logplex_url: "",
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    logplex_url: String.t,
    created_at: String.t,
    updated_at: String.t
  }
end

defimpl Happi.Endpoint, for: Happi.Heroku.Log.Session do
  def endpoint_url(_), do: "/log-sessions"
  def app?(_), do: true
end
