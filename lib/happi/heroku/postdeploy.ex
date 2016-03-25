defmodule Happi.Heroku.Postdeploy do
  
  @moduledoc """
  Heroku postdeploy structure.
  """
  
  @derive [Poison.Encoder]
  
  defstruct exit_code: 0, output: ""
  
  @type t :: %__MODULE__{exit_code: integer, output: String.t}
end
