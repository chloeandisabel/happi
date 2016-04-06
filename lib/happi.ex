defmodule Happi do
  @moduledoc """
  Happi is a Heroku API client.

  Defines a standard list of methods: list, get, create, update, and delete.
  """

  alias Happi.Endpoint
  alias Happi.Heroku.{App, Error}

  defstruct base_url: "",
    key: "",
    api: Happi.API,
    app: nil

  @type t :: %Happi{
    base_url: String.t,
    key: String.t,
    api: module,
    app: App.t
  }

  @api_url "https://api.heroku.com"

  # ================ Client creation ================

  @doc """
  Returns a client that can be used for further requests to the Heroku API.

  ## Options

     * `:api_key` - when not specified, it is read from the environment
       variable `HEROKU_API_KEY`

     * `:api_module` - when not specified, it is read from the config file

     * `:app` - a Heroku application name or id string

  ## Examples

     iex> Happi.api_client(api_key: "secret")
     %Happi{api: Happi.MockAPI, app: nil, base_url: "https://api.heroku.com",
       key: "secret"}

     iex> Happi.api_client(api_key: "secret", api_module: SomeModule)
     %Happi{api: SomeModule, app: nil, base_url: "https://api.heroku.com",
       key: "secret"}

     iex> Happi.api_client(api_key: "secret", app: "myapp")
     %Happi{api: Happi.MockAPI,
      app: %Happi.Heroku.App{archived_at: "2012-01-01T12:00:00Z",
       build_stack: %Happi.Heroku.Ref{id: "uuid", name: "cedar-14"},
       buildpack_provided_description: "Ruby/Rack",
       created_at: "2012-01-01T12:00:00Z",
       git_url: "https://git.heroku.com/example.git",
       id: "uuid", maintenance: false, name: "myapp",
       owner: %Happi.Heroku.User{email: "username@example.com", full_name: nil,
        id: "uuid"},
       region: %Happi.Heroku.Ref{id: "uuid", name: "us"},
       released_at: "2012-01-01T12:00:00Z", repo_size: 0, slug_size: 0,
       space: %Happi.Heroku.Ref{id: "uuid", name: "nasa"},
       stack: %Happi.Heroku.Ref{id: "uuid", name: "cedar-14"},
       updated_at: "2012-01-01T12:00:00Z",
       web_url: "https://example.herokuapp.com/"},
      base_url: "https://api.heroku.com",
      key: "secret"}
  """
  @spec api_client(Keyword.t) :: t
  def api_client(options \\ []) do
    key = Keyword.get(options, :api_key, System.get_env("HEROKU_API_KEY"))
    mod = Keyword.get(options, :api_module, Application.get_env(:happi, :api))
    app_identifier = Keyword.get(options, :app, System.get_env("HAPPI_HEROKU_APP"))

    client = %Happi{base_url: @api_url, key: key, api: mod}
    app = if app_identifier do
            client
            |> Map.put(:app, %{id: app_identifier})
            |> get(App, app_identifier)
          end
    %{client | app: app}
  end

  # ================ Heroku API endpoints ================

  @doc """
  Returns the current API rate limit (number of calls left).

  ## Examples

     iex> Happi.api_client |> Happi.rate_limit
     1234
  """
  @spec rate_limit(t) :: integer
  def rate_limit(client) do
    client
    |> client.api.get("/account/rate-limits")
    |> Poison.decode!
    |> Map.get("remaining")
  end

  # ================ Happi.Endpoint REST calls ================

  @doc """
  Gets a list of resources.

  ## Examples

     iex> Happi.api_client |> Happi.list(Happi.Heroku.App)
     [%Happi.Heroku.App{archived_at: "2012-01-01T12:00:00Z",
      build_stack: %Happi.Heroku.Ref{id: "uuid", name: "cedar-14"},
      buildpack_provided_description: "Ruby/Rack",
      created_at: "2012-01-01T12:00:00Z",
      git_url: "https://git.heroku.com/example.git",
      id: "uuid", maintenance: false, name: "myapp",
      owner: %Happi.Heroku.User{email: "username@example.com", full_name: nil,
       id: "uuid"},
      region: %Happi.Heroku.Ref{id: "uuid", name: "us"},
      released_at: "2012-01-01T12:00:00Z", repo_size: 0, slug_size: 0,
      space: %Happi.Heroku.Ref{id: "uuid", name: "nasa"},
      stack: %Happi.Heroku.Ref{id: "uuid", name: "cedar-14"},
      updated_at: "2012-01-01T12:00:00Z",
      web_url: "https://example.herokuapp.com/"}]
  """
  @spec list(t, module) :: [map]
  def list(client, module) do
    client
    |> client.api.get(url_for(client, module))
    |> decode!([struct(module)])
  end

  @doc """
  Gets a single resource.

  ## Examples

     iex> Happi.api_client |> Happi.get(Happi.Heroku.App, "myapp")
     %Happi.Heroku.App{archived_at: "2012-01-01T12:00:00Z",
      build_stack: %Happi.Heroku.Ref{id: "uuid", name: "cedar-14"},
      buildpack_provided_description: "Ruby/Rack",
      created_at: "2012-01-01T12:00:00Z",
      git_url: "https://git.heroku.com/example.git",
      id: "uuid", maintenance: false, name: "myapp",
      owner: %Happi.Heroku.User{email: "username@example.com", full_name: nil,
       id: "uuid"},
      region: %Happi.Heroku.Ref{id: "uuid", name: "us"},
      released_at: "2012-01-01T12:00:00Z", repo_size: 0, slug_size: 0,
      space: %Happi.Heroku.Ref{id: "uuid", name: "nasa"},
      stack: %Happi.Heroku.Ref{id: "uuid", name: "cedar-14"},
      updated_at: "2012-01-01T12:00:00Z",
      web_url: "https://example.herokuapp.com/"}

     iex> Happi.api_client |> Happi.get(Happi.Heroku.App, "no-such-app")
     %Happi.Heroku.Error{code: 404, id: "", message: "no such application", url: ""}
  """
  @spec get(t, module, String.t) :: map
  def get(client, module, id) do
    client
    |> client.api.get(url_for(client, module, id))
    |> decode!(struct(module))
  end

  @doc """
  Creates a resource.
  """
  @spec create(t, module, map) :: map
  def create(client, module, data) do
    client
    |> client.api.post(url_for(client, module), Poison.encode!(data))
    |> decode!([struct(module)])
  end

  @doc """
  Updates a resource.
  """
  @spec update(t, module, map) :: map
  def update(client, module, data) do
    client
    |> client.api.patch(url_for(client, module), Poison.encode!(data))
    |> decode!([struct(module)])
  end

  @doc """
  Deletes a resource.
  """
  @spec delete(t, module, String.t) :: map
  def delete(client, module, id) do
    client
    |> client.api.delete(url_for(client, module, id))
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

  # Given either an API response JSON string or an `Error`, either parses
  # the JSON as `decode_type` and returns that or returns the `Error`.
  @spec decode!(String.t | Error.t, module | Enum.t) :: map
  defp decode!(%Error{} = err, _) do
    err
  end
  defp decode!(body, decode_type) do
    body |> Poison.decode!(as: decode_type)
  end
end
