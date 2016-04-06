defmodule Happi.MockAPI do

  alias Happi.Heroku.{App, Ref, User, Error}

  @myapp %App{
    id: "uuid",
    name: "myapp",
    buildpack_provided_description: "Ruby/Rack",
    build_stack: %Ref{id: "uuid", name: "cedar-14"},
    git_url: "https://git.heroku.com/example.git",
    maintenance: false,
    owner: %User{email: "username@example.com", id: "uuid"},
    region: %Ref{id: "uuid", name: "us"},
    repo_size: 0,
    slug_size: 0,
    space: %Ref{id: "uuid", name: "nasa"},
    stack: %Ref{id: "uuid", name: "cedar-14"},
    web_url: "https://example.herokuapp.com/",
    created_at: "2012-01-01T12:00:00Z",
    released_at: "2012-01-01T12:00:00Z",
    archived_at: "2012-01-01T12:00:00Z",
    updated_at: "2012-01-01T12:00:00Z"
  }

  @doc """
  Performs a GET request to the Heroku API and returns the result body. Used
  by many of the `Happi.Heroku.*` modules.
  """
  def get(_client, "/apps") do
    Poison.encode! [@myapp]
  end
  def get(_client, "/apps/no-such-app") do
    %Error{code: 404, id: "", message: "no such application", url: ""}
  end
  def get(_client, "/apps/" <> app_name) do
    Poison.encode! %App{@myapp | name: app_name}
  end
  def get(_client, "/account/rate-limits") do
    Poison.encode! %{remaining: 1234}
  end
end
