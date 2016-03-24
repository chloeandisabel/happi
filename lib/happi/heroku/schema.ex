defmodule Happi.Heroku.Schema do
  
  @@doc """
  Returns the API schema as a simple Map with string keys.
  """
  def get(client) do
    client
    |> Happi.API.get("/schema")
    |> Poison.decode!
  end
end
