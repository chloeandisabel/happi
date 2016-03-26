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

```elixir
c = Happi.api_client("api-key")    # If no param, use $HEROKU_API_KEY
c = c |> Happi.set_app("app-name") # If no param, use $HAPPI_HEROKU_APP

Happi.list(c, Happi.Heroku.Dyno)   # For app in c
Happi.rate_limit
```

## To Do

- Have a way to limit what `Happi.{list,get,etc.}` methods are available for
  each `Happi.Heroku.*` type
- More endpoints
- Handle 206 Partial Content responses
- Handle ranges (name, order, max, etc.) in get requests
- Parse datetime strings
