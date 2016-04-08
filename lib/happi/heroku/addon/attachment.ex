defmodule Happi.Heroku.Addon.Attachment do
  
  @moduledoc """
  Heroku application add-on attachment.
  """
  
  alias Happi.Heroku.{Ref, Addon}

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

  @spec list(Happi.t) :: [t]
  def list(client) do
    client
    |> Happi.API.get(client, "/addon-attachments")
    |> Poison.deocde!(as: [%__MODULE__{}])
  end

  @spec list(Happi.t, String.t) :: [t]
  def list(client, addon_id_or_name) do
    client
    |> Happi.API.get(client, "/addons/#{addon_id_or_name}/addon-attachments")
    |> Poison.deocde!(as: [%__MODULE__{}])
  end

  @spec list_for_app(Happi.t) :: [t]
  def list_for_app(client) do
    client
    |> Happi.API.get(client, "/apps/#{client.app.id}/addon-attachments")
    |> Poison.deocde!(as: [%__MODULE__{}])
  end

  @spec get(Happi.t, String.t) :: t
  def get(client, addon_id) do
    client
    |> Happi.API.get(client, "/addon-attachments/#{addon_id}")
    |> Poison.deocde!(as: %__MODULE__{})
  end

  @spec get_for_app(Happi.t, String.t) :: t
  def get_for_app(client, addon_id) do
    client
    |> Happi.API.get(client, "/apps/#{client.app.id}/addon-attachments/#{addon_id}")
    |> Poison.deocde!(as: %__MODULE__{})
  end

  @spec create(Happi.t, Map.t) :: t
  def create(client, params) do
    client
    |> Happi.API.post(client, "/addon-attachments", Poison.encode!(params))
    |> Poison.deocde!(as: %__MODULE__{})
  end

  @spec delete(Happi.t, String.t) :: t
  def delete(client, id) do
    client
    |> Happi.API.delete(client, "/addon-attchments/#{id}")
    |> Poison.deocde!(as: %__MODULE__{})
  end
end
