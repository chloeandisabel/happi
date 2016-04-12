defmodule Happi.Resource do
  @moduledoc """
  Provides functions that call the Happi `list`, `get`, `create`, `update`,
  and `delete` functions by passing in the module that uses this one.

  For example, since `Happi.Heroku.App` uses this module, instead of having
  to call `Happi.list(client, Happi.Heroku.App)` you can call
  `Happi.Heroku.App.list(client)`.

  ## Options

     * `:only` - A list of atoms specifying which functions to define.
     * `:except` - A list of atoms specifying which functions to exclude.

     `:except` is processed first: a function name that is in an `:except`
     list will not be defined even if it is in the `:only` list.

  ## Using

      defmodule MyModule do
        use Happi.Resource, only: [:list, :get]
      end

      MyModule.list(client)

  ## Example

      iex> Happi.Heroku.App.list(Happi.api_client(app: "myapp"))
      [%Happi.Heroku.App{archived_at: {{2012, 1, 1}, {12, 0, 0}},
        build_stack: %Happi.Heroku.Ref{id: "uuid", name: "cedar-14"},
        buildpack_provided_description: "Ruby/Rack",
        created_at: {{2012, 1, 1}, {12, 0, 0}},
        git_url: "https://git.heroku.com/example.git", id: "app-uuid",
        maintenance: false, name: "myapp",
        owner: %Happi.Heroku.User{email: "username@example.com",
         full_name: nil, id: "uuid"},
        region: %Happi.Heroku.Ref{id: "uuid", name: "us"},
        released_at: {{2012, 1, 1}, {12, 0, 0}}, repo_size: 0,
        slug_size: 0, space: %Happi.Heroku.Ref{id: "uuid", name: "nasa"},
        stack: %Happi.Heroku.Ref{id: "uuid", name: "cedar-14"},
        updated_at: {{2012, 1, 1}, {12, 0, 0}},
        web_url: "https://example.herokuapp.com/"}]
  """

  defmacro __using__(opts) do
    quote do
      if Happi.Resource.should_define?(unquote(opts), :list) do
        def list(client), do: Happi.list(client, __MODULE__)
      end
      if Happi.Resource.should_define?(unquote(opts), :get) do
        def get(client, id), do: Happi.get(client, __MODULE__, id)
      end
      if Happi.Resource.should_define?(unquote(opts), :create) do
        def create(client, data), do: Happi.create(client, __MODULE__, data)
      end
      if Happi.Resource.should_define?(unquote(opts), :update) do
        def update(client, data), do: Happi.update(client, __MODULE__, data)
      end
      if Happi.Resource.should_define?(unquote(opts), :delete) do
        def delete(client, id), do: Happi.delete(client, __MODULE__, id)
      end
    end
  end

  def should_define?(opts, atom) do
    onlies = Keyword.get(opts, :only)
    exceptions = Keyword.get(opts, :except)
    cond do
      exceptions && exceptions |> Enum.member?(atom) -> true
      onlies && !(onlies |> Enum.member?(atom)) -> false
      true -> true
    end
  end
end
