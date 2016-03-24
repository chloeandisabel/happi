defmodule Happi.Heroku.Log.Session do
  
  @moduledoc """
  Heroku log drain.
  """
  
  @derive [Poison.Encoder]

  defstruct id: "",
    logplex_url: "",
    created_at: nil,
    updated_at: nil

  def create(client, options \\ []) do
    dyno = Keyword.get(options, :dyno, "web.1")
    lines = Keyword.get(options, :lines, 10)
    source = Keyword.get(options, :source, "app")
    tail = Keyword.get(options, :tail, true)
    client
    |> Happi.API.post("/apps/#{client.app.name}/log-sessions",
                      Poison.encode(%{dyno: dyno, lines: lines,
                                      source: source, tail: tail}))
    |> Poison.decode!(as: %Happi.Heroku.Log.Session{})
  end
end
