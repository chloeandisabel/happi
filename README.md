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

## To Do

- More endpoints
- Macros for standard REST behaviors, useable by Happi.Heroku.* modules to
  reduce the amount of code needed in each
- Handle 206 Partial Content responses
- Handle ranges (name, order, max, etc.) in get requests
- Parse datetime strings
