defmodule Happi.Heroku.OAuth.Token do
  
  defstruct id: "",
    token: "",
    expires_in: 0

  @type t :: %__MODULE__{
    id: String.t,
    token: String.t,
    expires_in: integer
  }
end
