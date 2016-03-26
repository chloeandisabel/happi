defmodule Happi.Heroku.Buildpack do
  
  @moduledoc """
  Heroku buildpack.
  """
  
  defstruct url: "",
    name: "",
    ordinal: 0                  # only used with buildpack installations

  @type t :: %__MODULE__{
    url: String.t,
    name: String.t,
    ordinal: integer
  }
end

defimpl Happi.Endpoint, for: Happi.Heroku.Buildpack do
  def endpoint_url(_), do: "/buildpack-installations"
  def app?(_), do: true
end
