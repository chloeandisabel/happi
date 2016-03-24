defmodule Happi.Heroku.Addon.Service do
  
  @moduledoc """
  Heroku add-on services.
  """
  
  defstruct id: "",
    name: "",
    cli_plugin_name: "",
    human_name: "",
    state: "",
    supports_multiple_installations: false,
    supports_sharing: false,
    created_at: nil,
    updated_at: nil

  def list(client) do
    client
    |> Happi.API.get("/addon-services")
    |> Poison.decode!(as: [%Happi.Heroku.Addon.Service{}])
  end

  def get(client, name_or_id) do
    client
    |> Happi.API.get("/addon-services/#{name_or_id}")
    |> Poison.decode!(as: %Happi.Heroku.Addon.Service{})
  end
end
