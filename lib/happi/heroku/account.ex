defmodule Happi.Heroku.Account do
  
  @moduledoc """
  Heroku Account.
  """

  @derive [Poison.Encoder]

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
end

defimpl Happi.Endpoint, for: Happi.Heroku.Account do
  def endpoint_url(_), do: "/account"
  def app?(_), do: false
end
