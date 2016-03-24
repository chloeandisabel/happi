defmodule Happi.Heroku.SourceBlob do
  
  @moduledoc """
  Heroku source blob.
  """

  @derive [Poison.Encoder]

  defstruct checksum: "",
    url: "",
    version: ""
end
