defmodule Happi.Heroku.Addon do
  @moduledoc """
  Heroku application add-on. See `Happi.Heroku.Addon.Attachment`.
  """
  
  alias Happi.Heroku.Ref
  alias Happi.Heroku.Addon.Service
  use Happi.Resource

  @derive [Poison.Encoder]
  
  defstruct id: "",
    name: "",
    app: %Ref{},
    addon_service: %Service{},
    config_vars: [],
    plan: %Ref{},
    provider_id: "",
    web_url: "",
    created_at: nil,
    updated_at: nil

  @type t :: %__MODULE__{
    id: String.t,
    name: String.t,
    app: Ref.t,
    addon_service: Service.t,
    config_vars: [],
    plan: Ref.t,
    provider_id: String.t,
    web_url: String.t,
    created_at: String.t,
    updated_at: String.t
  }

  @doc """
  Returns all addons, not just those for the app stored in `client`.
  """

  @spec list_all(Happi.t) :: [t]
  def list_all(client) do
    client
    |> client.api.get("/addons")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @doc """
  Returns a specific addon.
  """
  @spec get_addon(Happi.t, String.t) :: t
  def get_addon(client, name_or_id) do
    client
    |> client.api.get("/addons/#{name_or_id}")
    |> Poison.decode!(as: %__MODULE__{})
  end
end

defimpl Happi.Endpoint, for: Happi.Heroku.Addon do
  def endpoint_url(_), do: "/addons"
  def app_resource?(_), do: true
end
