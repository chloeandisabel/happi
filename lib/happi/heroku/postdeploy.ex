defmodule Happi.Heroku.Postdeploy do
  
  @moduledoc """
  Heroku postdeploy structure.
  """
  
  @derive [Poison.Encoder]
  
  defstruct exit_code: 0,
    output: ""
end
