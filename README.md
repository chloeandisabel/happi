# Happi

Happi is a collection of Elixir structs for
the
[Heroku API](https://devcenter.heroku.com/articles/platform-api-reference)
useable by the [Napper](https://github.com/chloeandisabel/napper) JSON REST
API application.

Happi defines structs for most of the resources exposed by Heroku's API, and
a few functions that are above and beyond the standard
list/get/update/delete REST API calls.

## Installation

First, add Happi to your `mix.exs` dependencies:

```elixir
def deps do
  [{:happi, git: "https://github.com/chloeandisabel/happi.git"}]
end
```

and run `$ mix deps.get`. Now, list the `:happi` application as your
application dependency:

```elixir
def applications do
  [applications: [:happi]]
end
```

## Configuration

We need to tell Napper about Heroku's API. This example assumes you've
defined the environment variable `HEROKU_API_KEY`.

```elixir
config :napper,
  url: "https://api.heroku.com",
  auth: "Bearer #{System.get_env("HEROKU_API_KEY")}",
  accept: "application/vnd.heroku+json; version=3",
  master_prefix: "/apps",
  master_id: "prod-app-name"
```

## Using Happi

First we create a client using Napper.

```elixir
iex> client = Napper.api_client
```

The example config file defines a default application name and the "/apps"
endpoint. This means that when using a struct such as `Dyno` you don't need
to specify the application name. To use a different application, specify a
different `master_id` in the client.

```elixir
iex> client = Napper.api_client(master_id: "another_app_name")
iex> # ...or, starting with an existing client...
iex> client = %{client | master_id: "another_app_name"}
```

Heroku's API limits the number of requests per hour. Let's find out how many
we have left:

```elixir
iex> client |> Happi.rate_limit
#=> 2400
```

What applications do we have?

```elixir
iex> client |> Happi.Heroku.App.list
#=> [%Happi.Heroku.App{...}]
```

What dynos does the "app-name-or-id" application have?

```elixir
iex> ds = client |> Happi.Heroku.Dyno.list
#=> [%Happi.Heroku.Dyno{...}]
```

Note that we didn't have to pass in the app name or id because it's already
stored in the client.

Let's fetch a particular dyno.

```elixir
iex> d = client |> Happi.Heroku.Dyno.get("my_dyno_name.1")
#=> %Happi.Heroku.Dyno{...}
```

How many dynos do we have of each dyno type? (You could also use the
`Formation` resource to get this information a bit easier.)

```elixir
iex> client |> Happi.Heroku.Dyno.list |> Enum.reduce(%{}, fn d, m ->
...>   Map.put(m, d.type, Map.get(m, d.type, 0) + 1)
...> end
#=> %{"web" => 2, "schedule_workers" => 2, "others" => 5}
```

## To Do

- More endpoints
- Handle 206 Partial Content responses
- Handle ranges (name, order, max, etc.) in get requests
