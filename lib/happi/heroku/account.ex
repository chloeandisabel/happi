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

  def get(client) do
    client
    |> Happi.API.get("/account")
    |> Poison.decode!(as: %Happi.Heroku.Account{})
  end

  def update(client, account) do
    client
    |> Happi.API.patch("/account", Poison.encode!(account))
  end

  def delete(client, account) do
    client
    |> Happi.API.delete("/account", Poison.encode!(account))
  end
end
