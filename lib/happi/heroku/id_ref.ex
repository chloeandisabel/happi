defmodule Happi.Heroku.IdRef do
  
  @moduledoc """
  Heroku id reference structure.
  """
  
  @derive [Poison.Encoder]
  
  defstruct id: ""
end
