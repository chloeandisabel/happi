defmodule Happi.Heroku.Account do
  
  @moduledoc """
  Heroku Account.
  """

  defstruct allow_tracking: true,
    beta: false,
    email: "",
    id: "",
    last_login: nil,
    name: "",
    sms_number: nil,
    two_factor_authentication: false,
    verified: false,
    default_organization: nil,
    created_at: nil,
    updated_at: nil,
    suspended_at: nil,
    delinquent_at: nil,
    password: nil,              # only used when updating
    new_password: nil           # ditto

  @type t :: %__MODULE__{
    allow_tracking: boolean,
    beta: boolean,
    email: String.t,
    id: String.t,
    last_login: String.t,       # TODO datetime
    name: String.t,
    sms_number: String.t,
    two_factor_authentication: boolean,
    verified: boolean,
    default_organization: String.t,
    created_at: String.t,       # TODO datetime
    updated_at: String.t,       # TODO datetime
    suspended_at: String.t,     # TODO datetime
    delinquent_at: String.t,    # TODO datetime
    password: String.t,         # only used when updating
    new_password: String.t      # ditto
  }

  @spec get(Happi.t) :: t
  def get(client) do
    client
    |> Happi.API.get("/account")
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec update(Happi.t, t) :: t
  def update(client, account) do
    client
    |> Happi.API.patch("/account", Poison.encode!(account))
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec delete(Happi.t, t) :: t
  def delete(client, account) do
    client
    |> Happi.API.delete("/account", Poison.encode!(account))
    |> Poison.decode!(as: %__MODULE__{})
  end
end
