defmodule Happi.Heroku.Schema do
  @doc """
  Returns the API schema as a simple Map with string keys.

  Only the `Happi.get` endpoint is useful.
  """
  @spec get(Happi.t) :: Map.t
  def get(client) do
    client
    |> client.api.get("/schema")
    |> Poison.decode!
  end
end
