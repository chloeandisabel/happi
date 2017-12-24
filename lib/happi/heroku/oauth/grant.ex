defmodule Happi.Heroku.OAuth.Grant do
  defstruct id: "",
            code: "",
            expires_in: 0

  @type t :: %__MODULE__{
          id: String.t(),
          code: String.t(),
          expires_in: integer
        }
end
