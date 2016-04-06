defmodule Happi do
  @moduledoc """
  Happi is a Heroku API client.

  Defines a standard list of methods: list, get, create, update, and delete.
  """

  alias Happi.Endpoint
  alias Happi.Heroku.{App, Error}

  defstruct base_url: "",
    key: "",
    app: nil

  @type t :: %Happi{
    base_url: String.t,
    key: String.t,
    app: App.t
  }

  @api_url "https://api.heroku.com"

  # ================ Client creation ================

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

  # ================ Heroku API endpoints ================

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

  # ================ Happi.Endpoint REST calls ================

  @spec list(t, module) :: [map]
  def list(client, module) do
    client
    |> Happi.API.get(url_for(client, module))
    |> decode!([struct(module)])
  end

  @spec get(t, module, String.t) :: map
  def get(client, module, id) do
    client
    |> Happi.API.get(url_for(client, module, id))
    |> decode!(struct(module))
  end

  @spec create(t, module, any) :: map
  def create(client, module, data) do
    client
    |> Happi.API.post(url_for(client, module), Poison.encode!(data))
    |> decode!([struct(module)])
  end

  @spec update(t, module, any) :: map
  def update(client, module, data) do
    client
    |> Happi.API.patch(url_for(client, module), Poison.encode!(data))
    |> decode!([struct(module)])
  end

  @spec delete(t, module, String.t) :: map
  def delete(client, module, id) do
    client
    |> Happi.API.delete(url_for(client, module, id))
    |> decode!([struct(module)])
  end

  # ================ Private helpers ================

  @spec url_for(t, module, String.t) :: String.t
  defp url_for(client, module, id) do
    url_for(client, module) <> "/#{id}"
  end

  @spec url_for(t, module) :: String.t
  defp url_for(client, module) do
    s = struct(module)
    url = Endpoint.endpoint_url(s)
    if Endpoint.app?(s) do
      "/apps/#{client.app.id}#{url}"
    else
      url
    end
  end

  @spec decode!(String.t | Error.t, module | Enum.t) :: map
  defp decode!(%Error{} = err, _) do
    err
  end
  defp decode!(body, decode_type) do
    body |> Poison.decode!(as: decode_type)
  end
end
