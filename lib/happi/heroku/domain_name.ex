defmodule Happi.Heroku.DomainName do
  
  @moduledoc """
  Heroku domain name.
  """
  
  @derive [Poison.Encoder]

  defstruct id: "",
    app_id: 0,
    base_domain: "",
    domain: "",
    default: 0,
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    app_id: integer,
    base_domain: String.t,
    domain: String.t,
    default: integer,
    created_at: String.t,
    updated_at: String.t
  }
end
