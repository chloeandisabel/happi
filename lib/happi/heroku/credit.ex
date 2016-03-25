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

  @type t :: %__MODULE__{
    id: String.t,
    amount: integer,
    balance: integer,
    title: String.t,
    created_at: String.t,       # TODO datetime
    updated_at: String.t        # TODO datetime
  }

  @spec list(Happi.t) :: [t]
  def list(client) do
    client
    |> Heroku.post("/account/credits")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @spec get(Happi.t, String.t) :: t
  def get(client, id) do
    client
    |> Heroku.post("/account/credits/#{id}")
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec create(Happi.t, Map.t) :: t
  def create(client, codes) do
    client
    |> Heroku.post("/account/credits", Poison.encode!(codes))
    |> Poison.decode!(as: %__MODULE__{})
  end
end
