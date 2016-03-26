defmodule Happi.Heroku.Key do
  
  @moduledoc """
  Heroku key.
  """
  
  @derive [Poison.Encoder]

  defstruct id: "",
    public_key: "",
    email: "",
    fingerprint: "",
    comment: "",
    updated_at: nil,
    created_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    public_key: String.t,
    email: String.t,
    fingerprint: String.t,
    comment: String.t,
    updated_at: String.t,       # TODO datetime
    created_at: String.t        # TODO datetime
  }
end

defimpl Happi.Endpoint, for: Happi.Heroku.Key do
  def endpoint_url(_), do: "/account/keys"
  def app?(_), do: false
end
