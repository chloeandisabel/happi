defmodule Happi.Heroku.SourceBlob do
  @moduledoc """
  Heroku source blob.
  """

  @derive [Poison.Encoder]

  defstruct checksum: "", url: "", version: ""

  @type t :: %__MODULE__{checksum: String.t(), url: String.t(), version: String.t()}
end
