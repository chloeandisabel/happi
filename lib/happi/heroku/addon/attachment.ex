defmodule Happi.Heroku.Addon.Attachment do
  
  @moduledoc """
  Heroku application add-on attachment.
  """
  
  @derive [Poison.Encoder]

  defstruct id: "",
    name: "",
    addon: %Happi.Heroku.Addon{},
    app: %Happi.Heroku.Ref{},
    created_at: "",
    updated_at: ""

  def list(client) do
    client
    |> Happi.API.get(client, "/addon-attachments")
    |> Poison.deocde!(as: [%Happi.Heroku.Addon.Attachment{}])
  end

  def list(client, addon_id_or_name) do
    client
    |> Happi.API.get(client, "/addons/#{addon_id_or_name}/addon-attachments")
    |> Poison.deocde!(as: [%Happi.Heroku.Addon.Attachment{}])
  end

  def list_for_app(client) do
    client
    |> Happi.API.get(client, "/apps/#{client.app.id}/addon-attachments")
    |> Poison.deocde!(as: [%Happi.Heroku.Addon.Attachment{}])
  end

  def get(client, addon_id) do
    client
    |> Happi.API.get(client, "/addon-attachments/#{addon_id}")
    |> Poison.deocde!(as: [%Happi.Heroku.Addon.Attachment{}])
  end

  def get_for_app(client, addon_id) do
    client
    |> Happi.API.get(client, "/apps/#{client.app.id}/addon-attachments/#{addon_id}")
    |> Poison.deocde!(as: [%Happi.Heroku.Addon.Attachment{}])
  end

  @doc """
  Creates an application add-on attachment. Returns a
  Happi.Heroku.Addon.Attachment structure.
  """
  @spec create(Happi.t, String.t, String.t, boolean, String.t) :: %Happi.Heroku.Addon.Attachment{}
  def create(client, addon_name_or_id, app_name_or_id, force \\ false, name \\ nil) do
    request = %{addon: addon_name_or_id,
                app: app_name_or_id,
                force: force}
    if name do
      request = request |> Map.put(:name, name)
    end
    client
    |> Happi.API.post(client, "/addon-attachments", request)
    |> Poison.deocde!(as: %Happi.Heroku.Addon.Attachment{})
  end

  def delete(client, attachment) do
    client
    |> Happi.API.delete(client, "/addon-attchments/#{attachment.id}")
    |> Poison.deocde!(as: %Happi.Heroku.Addon.Attachment{})
  end

end
