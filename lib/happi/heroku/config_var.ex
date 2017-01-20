defmodule Happi.Heroku.ConfigVar do
  @moduledoc """
  Heroku config variables, represented as Maps.
  """

  use Napper.Resource
end

defimpl Napper.Endpoint, for: Happi.Heroku.ConfigVar do
  def under_master_resource?(_), do: true
  def endpoint_url(_), do: "/config-vars"
end
