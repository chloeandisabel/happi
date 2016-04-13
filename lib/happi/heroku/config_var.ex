defmodule Happi.Heroku.ConfigVar do
  @moduledoc """
  Heroku config variables, represented as Maps.
  """

  use Happi.Resource
end

defimpl Happi.Endpoint, for: Happi.Heroku.ConfigVar do
  def endpoint_url(_), do: "/config-vars"
  def app_resource?(_), do: true
end
