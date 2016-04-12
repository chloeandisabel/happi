defmodule Happi.API do
  @moduledoc """
  Functions that implement HTTP methods. Used by `Happi` functions. They all
  take a `Happi` struct as their first argument.

  All of these functions return either JSON or a `Happi.Heroku.Error`
  struct. The caller needs to be able to handle either kind of response.
  """

  alias Happi.Heroku.Error

  @doc """
  Performs a GET request to the Heroku API and returns the result body. Used
  by many of the `Happi.Heroku.*` modules.

  Returns a `Happi.Heroku.Error` if the API signals an error.
  """
  @spec get(Happi.t, String.t) :: String.t | Error.t
  def get(client, path) do
    HTTPoison.get!("#{client.base_url}#{path}", headers(client))
    |> body_or_error
  end

  @doc """
  Performs a PATCH request to the Heroku API and returns the result body.
  Used by many of the `Happi.Heroku.*` modules.

  Returns a `Happi.Heroku.Error` if the API signals an error.
  """
  @spec patch(Happi.t, String.t, String.t) :: String.t | Error.t
  def patch(client, path, body) do
    HTTPoison.patch!("#{client.base_url}#{path}", body, headers(client))
    |> body_or_error
  end

  @doc """
  Performs a POST request to the Heroku API and returns the result body.
  Used by many of the `Happi.Heroku.*` modules.

  Returns a `Happi.Heroku.Error` if the API signals an error.
  """
  @spec post(Happi.t, String.t, String.t) :: String.t | Error.t
  def post(client, path, body) do
    HTTPoison.post!("#{client.base_url}#{path}", body, headers(client))
    |> body_or_error
  end

  @doc """
  Performs a DELETE request to the Heroku API and returns the result body.
  Used by many of the `Happi.Heroku.*` modules.

  Returns a `Happi.Heroku.Error` if the API signals an error.
  """
  @spec delete(Happi.t, String.t) :: String.t | Error.t
  def delete(client, path) do
    HTTPoison.delete!("#{client.base_url}#{path}", headers(client))
    |> body_or_error
  end

  @doc """
  Performs a HEAD request to the Heroku API and returns the result body.
  Used by many of the `Happi.Heroku.*` modules.

  Returns a `Happi.Heroku.Error` if the API signals an error.
  """
  @spec head(Happi.t, String.t) :: String.t | Error.t
  def head(client, path) do
    HTTPoison.head!("#{client.base_url}#{path}", headers(client))
    |> body_or_error
  end

  @spec body_or_error(HTTPoision.Response.t) :: String.t | Error.t
  defp body_or_error(%HTTPoison.Response{status_code: c} = r) when c < 400 do
    r.body
  end
  defp body_or_error(%HTTPoison.Response{status_code: c} = r) do
    r.body |> Poison.decode!(as: %Error{code: c})
  end

  @spec headers(Happi.t) :: map
  defp headers(client) do
    %{"Authorization": "Bearer #{client.key}",
      "Accept": "application/vnd.heroku+json; version=3",
		  "User-Agent": "#{Mix.Project.config[:app]}/#{Mix.Project.config[:version]}"}
  end
end
