defmodule Happi.Heroku.Credit do
  @moduledoc """
  Heroku credit.
  """

  use Napper.Resource

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
    created_at: String.t,
    updated_at: String.t
  }
end

defimpl Napper.Endpoint, for: Happi.Heroku.Credit do
  def under_master_resource?(_), do: false
  def endpoint_url(_), do: "/account/credits"
end
