defmodule Happi.Heroku.Error do
  @moduledoc """
  Heroku API error message.
  """

  defstruct code: 0,
            id: "",
            message: "",
            url: ""

  @type t :: %__MODULE__{
          code: integer,
          id: String.t(),
          message: String.t(),
          url: String.t()
        }
end
