defmodule Happi.Heroku.OAuth.Client do
  
  defstruct id: "",
    name: "",
    redirect_uri: ""
  
  @type t :: %__MODULE__{
    id: String.t,
    name: String.t,
    redirect_uri: String.t
  }
end
