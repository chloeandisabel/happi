defmodule Happi.Heroku.Account do
  @moduledoc """
  Heroku Account.
  """

  use Napper.Resource

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
            # only used when updating
            password: nil,
            # ditto
            new_password: nil

  @type t :: %__MODULE__{
          allow_tracking: boolean,
          beta: boolean,
          email: String.t(),
          id: String.t(),
          last_login: String.t(),
          name: String.t(),
          sms_number: String.t(),
          two_factor_authentication: boolean,
          verified: boolean,
          default_organization: String.t(),
          created_at: String.t(),
          updated_at: String.t(),
          suspended_at: String.t(),
          delinquent_at: String.t(),
          # only used when updating
          password: String.t(),
          # ditto
          new_password: String.t()
        }
end

defimpl Napper.Endpoint, for: Happi.Heroku.Account do
  def under_master_resource?(_), do: false
  def endpoint_url(_), do: "/account"
end
