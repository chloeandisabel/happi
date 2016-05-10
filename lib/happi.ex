defmodule Happi do
  @moduledoc """
  Happi is a Heroku API client.

  Defines a standard list of methods: list, get, create, update, and delete.
  """

  alias Happi.Endpoint

  defstruct base_url: nil,
    key: nil,
    api: Happi.API,
    app: nil

  @type t :: %Happi{
    base_url: String.t,
    key: String.t,
    api: module,
    app: String.t
  }

  @api_module Application.get_env(:happi, :api)
  @api_url "https://api.heroku.com"

  # ================ Client creation ================

  @doc """
  Returns a client struct that can be used for further requests to the
  Heroku API. The client contains information needed to connect to Heroku's
  API.

  The client struct also optinally contains an application id or name which
  will be used to retrieve application resources such as dynos. Storing an
  app id or name in the client means that you don't have to pass it in to
  every call about application resources such as dynos, collaborators, and
  buildpacks.

  To retrieve app resources from a different application, create a new
  client containing the other application id or name, or simply replace the
  app name in the client you have. (Of course, since Elixir is immutable
  under the hood, you're really creating a new client struct anyway.) See the
  example below.

  ## Options

     * `:api_key` - Your Heroku API key. When not specified, it is read from
       the environment variable `$HEROKU_API_KEY`.

     * `:app` - A Heroku application name or id string. When not specified,
       the environment variable `$HAPPI_HEROKU_APP` is used.

  ## Examples

     (The API module is Happi.MockAPI in these examples because that's what
     is used in the test environment when these examples are run as tests.)

     iex> Happi.api_client(api_key: "secret")
     %Happi{api: Happi.MockAPI, app: nil, base_url: "https://api.heroku.com",
       key: "secret"}

     iex> Happi.api_client(api_key: "secret")
     %Happi{api: Happi.MockAPI, app: nil, base_url: "https://api.heroku.com",
       key: "secret"}

     iex> Happi.api_client(api_key: "secret", app: "myapp")
     %Happi{api: Happi.MockAPI, app: "myapp",
      base_url: "https://api.heroku.com", key: "secret"}

     Here's an example of building a client struct for another app, given an
     existing client struct.

     iex> client = Happi.api_client(api_key: "secret")
     ...> client = %{client | app: "app-uuid-or-name"}
     ...> client
     %Happi{api: Happi.MockAPI, app: "app-uuid-or-name",
      base_url: "https://api.heroku.com", key: "secret"}
  """
  @spec api_client(Keyword.t) :: t
  def api_client(options \\ []) do
    key = Keyword.get(options, :api_key, System.get_env("HEROKU_API_KEY"))
    app = Keyword.get(options, :app, System.get_env("HAPPI_HEROKU_APP"))
    %Happi{api: @api_module, app: app, base_url: @api_url, key: key}
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
  Gets a list of resources. The id of the application in `client` is used to
  retrieve resources such as dynos that are owned by applications.

  ## Examples

     iex> Happi.api_client |> Happi.list(Happi.Heroku.App)
     [%Happi.Heroku.App{archived_at: {{2012, 1, 1}, {12, 0, 0}},
      build_stack: %Happi.Heroku.Ref{id: "uuid", name: "cedar-14"},
      buildpack_provided_description: "Ruby/Rack",
      created_at: {{2012, 1, 1}, {12, 0, 0}},
      git_url: "https://git.heroku.com/example.git",
      id: "app-uuid", maintenance: false, name: "myapp",
      owner: %Happi.Heroku.User{email: "username@example.com", full_name: nil,
       id: "uuid"},
      region: %Happi.Heroku.Ref{id: "uuid", name: "us"},
      released_at: {{2012, 1, 1}, {12, 0, 0}}, repo_size: 0, slug_size: 0,
      space: %Happi.Heroku.Ref{id: "uuid", name: "nasa"},
      stack: %Happi.Heroku.Ref{id: "uuid", name: "cedar-14"},
      updated_at: {{2012, 1, 1}, {12, 0, 0}},
      web_url: "https://example.herokuapp.com/"}]

     iex> Happi.api_client(app: "myapp") |> Happi.list(Happi.Heroku.Dyno)
     [%Happi.Heroku.Dyno{id: "dyno-uuid", name: "mydyno", attach_url: nil,
      command: "command that started dyno",
      app: %Happi.Heroku.Ref{id: "app-uuid", name: "myapp"},
      release: %Happi.Heroku.Release{id: "uuid", version: 1},
      size: "small 1X", type: "type", state: "Rhode Island",
      created_at: {{2012, 1, 1}, {12, 0, 0}},
      updated_at: {{2012, 1, 1}, {12, 0, 0}}}]
  """
  @spec list(t, module) :: [map]
  def list(client, module) do
    client
    |> client.api.get(url_for(client, module))
    |> Happi.Transform.decode!([struct(module)])
  end

  @doc """
  Gets a single resource.

  ## Examples

     iex> Happi.api_client |> Happi.get(Happi.Heroku.App, "myapp")
     %Happi.Heroku.App{archived_at: {{2012, 1, 1}, {12, 0, 0}},
      build_stack: %Happi.Heroku.Ref{id: "uuid", name: "cedar-14"},
      buildpack_provided_description: "Ruby/Rack",
      created_at: {{2012, 1, 1}, {12, 0, 0}},
      git_url: "https://git.heroku.com/example.git",
      id: "app-uuid", maintenance: false, name: "myapp",
      owner: %Happi.Heroku.User{email: "username@example.com", full_name: nil,
       id: "uuid"},
      region: %Happi.Heroku.Ref{id: "uuid", name: "us"},
      released_at: {{2012, 1, 1}, {12, 0, 0}}, repo_size: 0, slug_size: 0,
      space: %Happi.Heroku.Ref{id: "uuid", name: "nasa"},
      stack: %Happi.Heroku.Ref{id: "uuid", name: "cedar-14"},
      updated_at: {{2012, 1, 1}, {12, 0, 0}},
      web_url: "https://example.herokuapp.com/"}

     iex> Happi.api_client |> Happi.get(Happi.Heroku.App, "no-such-app")
     %Happi.Heroku.Error{code: 404, id: "", message: "no such application", url: ""}
  """
  @spec get(t, module, String.t) :: map
  def get(client, module, id) do
    client
    |> client.api.get(url_for(client, module, id))
    |> Happi.Transform.decode!(struct(module))
  end

  @doc """
  Creates a resource.
  """
  @spec create(t, module, map) :: map
  def create(client, module, data) do
    client
    |> client.api.post(url_for(client, module), Happi.Transform.encode!(data))
    |> Happi.Transform.decode!([struct(module)])
  end

  @doc """
  Updates a resource.
  """
  @spec update(t, module, map) :: map
  def update(client, module, data) do
    client
    |> client.api.patch(url_for(client, module), Happi.Transform.encode!(data))
    |> Happi.Transform.decode!([struct(module)])
  end

  @doc """
  Deletes a resource.
  """
  @spec delete(t, module, String.t) :: map
  def delete(client, module, id) do
    client
    |> client.api.delete(url_for(client, module, id))
    |> Happi.Transform.decode!([struct(module)])
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
    if Endpoint.app_resource?(s) do
      "/apps/#{client.app}#{url}"
    else
      url
    end
  end
end
