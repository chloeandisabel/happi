defmodule Happi.Heroku.Schema do
  
  @doc """
  Returns the API schema as a simple Map with string keys.
  """
  @spec get(Happi.t) :: Map.t
  def get(client) do
    client
    |> Happi.API.get("/schema")
    |> Poison.decode!
  end
end
