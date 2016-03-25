defmodule Happi.Heroku.Ref do
  
  @moduledoc """
  Heroku id/name reference structure.
  """
  
  @derive [Poison.Encoder]
  
  defstruct id: "", name: ""

  @type t :: %Happi.Heroku.Ref{id: String.t, name: String.t}
end
