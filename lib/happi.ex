defmodule Happi do
  @moduledoc """
  Happi is a Heroku API client.

  Defines a standard list of methods: list, get, create, update, and delete.
  """

  alias Happi.Endpoint
  alias Happi.Heroku.App

  defstruct base_url: "",
    key: "",
    app: nil

  @type t :: %Happi{
    base_url: String.t,
    key: String.t,
    app: App.t
  }

  @api_url "https://api.heroku.com"

  @doc """
  Returns a client that can be used for further requests to the Heroku API.
  Takes an optional API key. If not specified, it is read from the
  environment variable `HEROKU_API_KEY`.
  """
  @spec api_client(String.t) :: t
  def api_client(api_key \\ nil) do
    key = if api_key, do: api_key, else: System.get_env("HEROKU_API_KEY")
    unless key do
      raise ArgumentError,
        message: "Heroku API key not specified and HEROKU_API_KEY not defined"
    end
    %{base_url: @api_url, key: key}
  end

  @doc """
  Returns a client with an `:app` entry containing the app specified by
  `name_or_id`. If not specified, the app name or id is read from the
  environment variable `HAPPI_HEROKU_APP`.

  This is useful because many of the Heroku API calls require an app id or
  name. Instead of having to pass it around, Happi modules assume they can
  find the app in the client.
  """
  @spec set_app(t) :: t
  def set_app(client, name_or_id \\ nil) do
    unless name_or_id do
      name_or_id = System.get_env("HAPPI_HEROKU_APP")
    end
    unless name_or_id do
      raise ArgumentError,
        message: "Heroku app name or id not specified and HAPPI_HEROKU_APP not defined"
    end
    app = client
    |> Map.put(:app, %{id: name_or_id})
    |> get(App, name_or_id)
    client |> Map.put(:app, app)
  end

  @doc """
  Returns the current API rate limit (number of calls left).
  """
  @spec rate_limit(t) :: integer
  def rate_limit(client) do
    client
    |> Happi.API.get("/account/rate-limits")
    |> Poison.decode!
    |> Map.get("remaining")
  end

  @spec list(Happi.t, module) :: [any]
  def list(client, module) do
    client
    |> Happi.API.get(url_for(client, module))
    |> Poison.decode!(as: [struct(module)])
  end

  @spec get(Happi.t, module, String.t) :: any
  def get(client, module, id) do
    client
    |> Happi.API.get(url_for(client, module, id))
    |> Poison.decode!(as: struct(module))
  end

  @spec create(Happi.t, module, any) :: any
  def create(client, module, data) do
    client
    |> Happi.API.post(url_for(client, module), Poison.encode!(data))
    |> Poison.decode!(as: [struct(module)])
  end

  @spec update(Happi.t, module, any) :: any
  def update(client, module, data) do
    client
    |> Happi.API.patch(url_for(client, module), Poison.encode!(data))
    |> Poison.decode!(as: [struct(module)])
  end

  @spec delete(Happi.t, module, String.t) :: any
  def delete(client, module, id) do
    client
    |> Happi.API.delete(url_for(client, module, id))
    |> Poison.decode!(as: [struct(module)])
  end

  defp url_for(client, module, id) do
    url_for(client, module) <> "/#{id}"
  end

  defp url_for(client, module) do
    s = struct(module)
    if Endpoint.app?(s) do
      "/apps/#{client.app.id}#{Endpoint.endpoint_url(s)}"
    else
      Endpoint.endpoint_url(s)
    end
  end
end
