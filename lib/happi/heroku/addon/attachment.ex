defmodule Happi.Heroku.Addon.Attachment do
  @moduledoc """
  Heroku application add-on attachment.
  """
  
  alias Happi.Heroku.{Ref, Addon}
  use Happi.Resource

  @derive [Poison.Encoder]

  defstruct id: "",
    name: "",
    addon: %Addon{},
    app: %Ref{},
    created_at: "",
    updated_at: ""

  @type t :: %__MODULE__{
    id: String.t,
    name: String.t,
    addon: Addon.t,
    app: Ref.t,
    created_at: String.t,
    updated_at: String.t
  }

  @spec list(Happi.t, String.t) :: [t]
  def list(client, addon_id_or_name) do
    client
    |> client.api.get("/addons/#{addon_id_or_name}/addon-attachments")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @spec list_for_app(Happi.t) :: [t]
  def list_for_app(client) do
    client
    |> client.api.get("/apps/#{client.app.id}/addon-attachments")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @spec get_for_app(Happi.t, String.t) :: t
  def get_for_app(client, addon_id) do
    client
    |> client.api.get("/apps/#{client.app.id}/addon-attachments/#{addon_id}")
    |> Poison.decode!(as: %__MODULE__{})
  end
end

defimpl Happi.Endpoint, for: Happi.Heroku.Addon.Attachment do
  def endpoint_url(_), do: "/addon-attachments"
  def app_resource?(_), do: false
end
