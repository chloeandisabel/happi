defmodule Happi.Heroku.Log.Session do
  
  @moduledoc """
  Heroku log drain.
  """
  
  @derive [Poison.Encoder]

  defstruct id: "",
    logplex_url: "",
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    logplex_url: String.t,
    created_at: String.t,       # TODO datetime
    updated_at: String.t        # TODO datetime
  }

  @spec create(Happi.t, Keyword.t) :: t
  def create(client, options \\ []) do
    client
    |> Happi.API.post("/apps/#{client.app.name}/log-sessions",
                      Poison.encode!(options))
    |> Poison.decode!(as: %__MODULE__{})
  end
end
