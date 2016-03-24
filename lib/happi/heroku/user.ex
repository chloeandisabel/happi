defmodule Happi.Heroku.User do
  
  @moduledoc """
  Heroku id/name reference structure.
  """
  
  @derive [Poison.Encoder]
  
  defstruct id: "",
    email: "",
    full_name: nil
end
