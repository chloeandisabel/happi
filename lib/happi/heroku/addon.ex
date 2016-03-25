defmodule Happi.Heroku.Addon do
  
  @moduledoc """
  Heroku application add-on. See `Happi.Heroku.Addon.Attachment`.
  """
  
  alias Happi.Heroku.Ref
  alias Happi.Heroku.Addon.Service

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
    created_at: String.t,       # TODO datetime
    updated_at: String.t        # TODO datetime
  }

  @spec list(Happi.t) :: [t]
  def list(client) do
    client
    |> Happi.API.get("/addons")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @doc """
  Returns a list of addons for the current app.
  """
  @spec list_for_app(Happi.t) :: [t]
  def list_for_app(client) do
    client
    |> Happi.API.get("/apps/#{client.app.id}/addons")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @spec get(Happi.t, String.t) :: t
  def get(client, name_or_id) do
    client
    |> Happi.API.get("/addons/#{name_or_id}")
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec create(Happi.t, t) :: t
  def create(client, addon) do
    client
    |> Happi.API.post("/apps/#{client.app.id}/addons",
                      Poison.encode!(addon))
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec update(Happi.t, t) :: t
  def update(client, addon) do
    client
    |> Happi.API.patch("/apps/#{client.app.id}/addons/#{addon.id}",
                       Poison.encode!(addon))
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec delete(Happi.t, t) :: t
  def delete(client, addon) do
    client
    |> Happi.API.delete("/apps/#{client.app.id}/addons/#{addon.id}")
    |> Poison.decode!(as: %__MODULE__{})
  end
end
