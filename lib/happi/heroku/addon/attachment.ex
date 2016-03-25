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
    created_at: String.t,       # TODO datetime
    updated_at: String.t        # TODO datetime
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

  @doc """
  Creates an application add-on attachment. Returns a
  __MODULE__ structure.
  """
  @spec create(Happi.t, String.t, String.t, boolean, String.t) :: t
  def create(client, addon_name_or_id, app_name_or_id, force \\ false, name \\ nil) do
    request = %{addon: addon_name_or_id,
                app: app_name_or_id,
                force: force}
    if name do
      request = request |> Map.put(:name, name)
    end
    client
    |> Happi.API.post(client, "/addon-attachments", request)
    |> Poison.deocde!(as: %__MODULE__{})
  end

  @spec delete(Happi.t, t) :: t
  def delete(client, attachment) do
    client
    |> Happi.API.delete(client, "/addon-attchments/#{attachment.id}")
    |> Poison.deocde!(as: %__MODULE__{})
  end
end
