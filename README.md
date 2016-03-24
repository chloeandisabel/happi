# Happi

Happi is a Heroku API client.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add happi to your list of dependencies in `mix.exs`:

        def deps do
          [{:happi, "~> 0.0.1"}]
        end

  2. Ensure happi is started before your application:

        def application do
          [applications: [:happi]]
        end

## Running

The environment variable `HEROKU_API_KEY` must be defined. Optionally, you
can define `HEROKU_APP` and it will be used as the default app for all
requests.

## Usage

## To Do

- Key,...
- Macros for standard REST behaviors, useable by Happi.Heroku.* modules
- Setup module
- Handle 206 Partial Content responses
- Handle ranges (name, order, max, etc.) in get requests
- Parse datetime strings
