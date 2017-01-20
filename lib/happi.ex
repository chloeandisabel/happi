defmodule Happi do
  @moduledoc """
  Happi is a collection of Heroku API resource definitions useable by
  [Napper](https://github.com/chloeandisabel/napper).
  """


  @doc """
  Returns the current API rate limit (number of calls left).
  """
  @spec rate_limit(Napper.t) :: integer
  def rate_limit(client) do
    client
    |> client.api.get("/account/rate-limits")
    |> Poison.decode!
    |> Map.get("remaining")
  end
end
