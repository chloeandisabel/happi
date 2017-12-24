defmodule Happi.Heroku.Log.Session do
  @moduledoc """
  Heroku log drain.
  """

  use Napper.Resource, only: [:create]

  @derive [Poison.Encoder]

  defstruct id: "",
            logplex_url: "",
            created_at: nil,
            updated_at: nil

  @type t :: %__MODULE__{
          id: String.t(),
          logplex_url: String.t(),
          created_at: String.t(),
          updated_at: String.t()
        }
end

defimpl Napper.Endpoint, for: Happi.Heroku.Log.Session do
  def under_master_resource?(_), do: true
  def endpoint_url(_), do: "/log-sessions"
end
