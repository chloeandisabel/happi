defmodule Happi.Heroku.Credit do
  
  @moduledoc """
  Heroku credit.
  """

  @derive [Poison.Encoder]

  defstruct id: "",
    amount: 0,
    balance: 0,
    title: "",
    created_at: nil,
    updated_at: nil

  def list(client) do
    client
    |> Heroku.post("/account/credits")
    |> Poison.decode!(as: [%Happi.Heroku.Credit{}])
  end

  def get(client, id) do
    client
    |> Heroku.post("/account/credits/#{id}")
    |> Poison.decode!(as: %Happi.Heroku.Credit{})
  end

  def create(client, code1 \\ nil, code2 \\ nil) do
    client
    |> Heroku.post("/account/credits",
                   Poison.encode!(%{code1: code1, code2: code2}))
    |> Poison.decode!(as: %Happi.Heroku.Credit{})
  end
end
