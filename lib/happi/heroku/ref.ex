defmodule Happi.Heroku.Ref do
  
  @moduledoc """
  Heroku id/name reference structure.
  """
  
  @derive [Poison.Encoder]
  
  defstruct id: "",
    name: ""
end
