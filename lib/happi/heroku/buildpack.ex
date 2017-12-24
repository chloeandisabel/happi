defmodule Happi.Heroku.Buildpack do
  @moduledoc """
  Heroku buildpack.
  """

  use Napper.Resource

  defstruct url: "",
            name: "",
            # only used with buildpack installations
            ordinal: 0

  @type t :: %__MODULE__{
          url: String.t(),
          name: String.t(),
          ordinal: integer
        }
end

defimpl Napper.Endpoint, for: Happi.Heroku.Buildpack do
  def under_master_resource?(_), do: true
  def endpoint_url(_), do: "/buildpack-installations"
end
