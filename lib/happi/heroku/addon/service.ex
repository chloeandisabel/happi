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

  @type t :: %__MODULE__{
    id: String.t,
    name: String.t,
    cli_plugin_name: String.t,
    human_name: String.t,
    state: String.t,
    supports_multiple_installations: boolean,
    supports_sharing: boolean,
    created_at: String.t,       # TODO datetime
    updated_at: String.t        # TODO datetime
  }

  @spec list(Happi.t) :: t
  def list(client) do
    client
    |> Happi.API.get("/addon-services")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @spec get(Happi.t, String.t) :: t
  def get(client, name_or_id) do
    client
    |> Happi.API.get("/addon-services/#{name_or_id}")
    |> Poison.decode!(as: %__MODULE__{})
  end
end
