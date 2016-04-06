# Happi

Happi is a Heroku API client.

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

## Running

If defined, the environment variable `HEROKU_API_KEY` will be the default
API key. Likewise, `HAPPI_HEROKU_APP` is the optionaly default application
name.

## Usage

First we create a client.

```elixir
iex> client = Happi.api_client("api-key") |> Happi.set_app("app-name")
```

`api_client/1` returns a `Happi.t` struct. The API key argument is optional;
if it is not passed in then the environment variable `$HEROKU_API_KEY` is
used.

`set_app/1` adds a `Happi.Heroku.App.t` struct to the client. This is useful
because many Heroku API structs such as `Dyno` are resources within an
`App`. Instead of having to obtain and pass around the `App` struct, keeping
it in the client struct reduces the number of arguments that need to be
passed around. The application name argument is optional; if it is not
passed in then the environment variable `$HAPPI_HEROKU_APP` by used.

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

What dynos does the "app-name" application have?

```elixir
iex> ds = client |> Happi.list(Happi.Heroku.Dyno)
#=> [%Happi.Heroku.Dyno{...}]
```

Note that we didn't have to pass in the app name or an `App` struct because
it's already stored in the client.

Want to spawn multiple requests in parallel? That's easy with Elixir's
`Task` module. In this example we call `update/1` on all our Dynos. This
would be a no-op since the updated struct is the same as the original.

```elixir
iex> f = fn(d) -> Task.async(client |> Happi.update(Dyno, d)) end
iex> ds |> Enum.map(f) |> Enum.map(&Task.await/1)
```

## To Do

- Tests
- Have a way to limit what `Happi.{list,get,etc.}` methods are available for
  each `Happi.Heroku.*` type
- More endpoints
- Handle 206 Partial Content responses
- Handle ranges (name, order, max, etc.) in get requests
- Parse datetime strings
