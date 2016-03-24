defmodule Happi.Heroku.Error do
  
  @moduledoc """
  Heroku API error message.
  """
  
  defstruct code: 0,
    id: "",
    message: "",
    url: ""

end
