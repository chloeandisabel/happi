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
end
