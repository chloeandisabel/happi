# Happi

Happi is a
[Heroku API](https://devcenter.heroku.com/articles/platform-api-reference)
client written in [Elixir](http://elixir-lang.org/).

Happi provides structs for most of the resources exposed by Heroku's API. A
standard set of functions (`list/2`, `get/3`, `create/3`, `update/3`, and
`delete/3`) is useable by all of them. Some structs come with additional
functions as dictated by the Heroku API.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be
installed as:

  1. Add happi to your list of dependencies in `mix.exs`:

        def deps do
          [{:happi, "~> 0.0.1"}]
        end

  2. Ensure happi is started before your application:

        def application do
          [applications: [:happi]]
        end

## Using Happi

First we create a client.

```elixir
iex> client = Happi.api_client(api_key: "secret", app: "app-name-or-id")
```

`api_client/1` returns a `Happi.t` struct. The API key argument is optional;
if it is not passed in then the environment variable `$HEROKU_API_KEY` is
used. The app argument is an app name or id which is optional and will
default to `$HAPPI_HEROKU_APP` or nil.

Many Heroku API structs such as `Dyno` are resources within an `App`.
Instead of having to obtain and pass around the `App` struct, keeping it in
the client struct reduces the number of arguments that need to be passed
around.

Heroku's API limits the number of requests per hour. Let's find out how many
we have left:

```elixir
iex> client |> Happi.rate_limit
#=> 2400
```

What applications do we have?

```elixir
iex> client |> Happi.list(Happi.Heroku.App)
#=> [%Happi.Heroku.App{...}]
```

What dynos does the "app-name-or-id" application have?

```elixir
iex> ds = client |> Happi.list(Happi.Heroku.Dyno)
#=> [%Happi.Heroku.Dyno{...}]
```

Note that we didn't have to pass in the app name or an `App` struct because
it's already stored in the client.

Want to spawn multiple requests in parallel? That's easy with Elixir's
`Task` module. In this example we call `update/1` on all our Dynos. This
example is a no-op since the updated struct is the same as the original.

```elixir
iex> f = fn(d) -> Task.async(client |> Happi.update(Dyno, d)) end
iex> ds |> Enum.map(f) |> Enum.map(&Task.await/1)
```

## Configuration

The only Happi application configuration option is `:api` which specifies
the module that implements the basic HTTP `get`, `post`, `delete`, etc.
commands. This allows the tests to use a mock API. Normally you won't have
to change this value.

## To Do

- Have a way to limit what `Happi.{list,get,etc.}` methods are available for
  each `Happi.Heroku.*` type
- More endpoints
- Handle 206 Partial Content responses
- Handle ranges (name, order, max, etc.) in get requests
- Parse datetime strings. We could either return Elixir-style datetime
  tuples or seconds since the epoch.

