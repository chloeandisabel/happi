defmodule Happi.Resource do
  
  @moduledoc """
  Defines a standard list of methods: list, get, create, update, and delete.
  """

  @doc false
  defmacro __using__(options) do
    IO.puts "inside using"
    except = Keyword.get(options, :except, [])
    IO.inspect except
    only = Keyword.get(options, :only, [])
    IO.inspect only
    url = options[:url]
    IO.inspect url
    unless url do
      raise ArgumentError, message: "required url argument is missing"
    end
    url_prefix = if Keyword.get(options, :app, false) do
      "/apps/\#{client.app.id}"
    else
      ""
    end
    IO.inspect url_prefix

    if should_define?(except, only, list: 1) do
      IO.puts "defining list(client)" # DEBUG
      quoted_code = quote do
        def list(client) do
          client
          |> Happi.API.get(unquote(url_prefix) <> unquote(url))
          |> Poison.decode!(as: [%__MODULE__{}])
        end
        # defoverridable list: 1
      end
      IO.inspect quoted_code
      IO.puts Macro.to_string(quoted_code)
      quoted_code
    end

    if should_define?(except, only, get: 2) do
      quote do
        def get(client, id) do
          client
          |> Happi.API.get(unquote(url_prefix) <> unquote(url) <> "/#{id}")
          |> Poison.decode!(as: [%__MODULE__{}])
        end
        defoverridable get: 1
      end
    end

    if should_define?(except, only, create: 2) do
      quote do
        def create(client, params) do
          client
          |> Happi.API.put(unquote(url_prefix) <> unquote(url),
                           Poison.encode!(params))
          |> Poison.decode!(as: [%__MODULE__{}])
        end
        defoverridable create: 2
      end
    end

    if should_define?(except, only, update: 2) do
      quote do
        def update(client, struct) do
          client
          |> Happi.API.patch(unquote(url_prefix) <> unquote(url),
                             Poison.encode!(struct, as: %__MODULE__{}))
          |> Poison.decode!(as: [%__MODULE__{}])
        end
        defoverridable update: 2
      end
    end

    if should_define?(except, only, delete: 2) do
      quote do
        def delete(client, id) do
          client
          |> Happi.API.delete(unquote(url_prefix) <> unquote(url) <> "/#{id}")
          |> Poison.decode!(as: [%__MODULE__{}])
        end
        defoverridable delete: 2
      end
    end
  end

  defp should_define?([], [], _) do
    true
  end
  defp should_define?([], only, [{name, arity}]) do
    Keyword.get(only, name) == arity
  end
  defp should_define?(except, [], [{name, arity}]) do
    Keyword.get(except, name) != arity
  end
end
