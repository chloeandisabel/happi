defmodule Happi.Heroku.Key do
  @moduledoc """
  Heroku key.
  """

  use Napper.Resource

  @derive [Poison.Encoder]

  defstruct id: "",
            public_key: "",
            email: "",
            fingerprint: "",
            comment: "",
            updated_at: nil,
            created_at: nil

  @type t :: %__MODULE__{
          id: String.t(),
          public_key: String.t(),
          email: String.t(),
          fingerprint: String.t(),
          comment: String.t(),
          updated_at: String.t(),
          created_at: String.t()
        }
end

defimpl Napper.Endpoint, for: Happi.Heroku.Key do
  def under_master_resource?(_), do: false
  def endpoint_url(_), do: "/account/keys"
end
