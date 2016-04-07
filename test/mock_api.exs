defmodule Happi.MockAPI do

  alias Happi.Heroku.{App, Dyno, Release, Ref, User, Error}

  @myapp %App{
    id: "app-uuid",
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

  @mydyno %Dyno{
    id: "dyno-uuid",
    name: "mydyno",
    attach_url: nil,
    command: "command that started dyno",
    app: %Ref{id: "app-uuid", name: "myapp"},
    release: %Release{id: "uuid", version: 1},
    size: "small 1X",
    state: "Rhode Island",
    type: "type",
    created_at: "2012-01-01T12:00:00Z",
    updated_at: "2012-01-01T12:00:00Z"
  }

  def get(_client, "/apps") do
    Poison.encode! [@myapp]
  end
  def get(_client, "/apps/no-such-app") do
    %Error{code: 404, id: "", message: "no such application", url: ""}
  end
  def get(_client, "/apps/myapp/dynos") do
    Poison.encode! [@mydyno]
  end
  def get(_client, "/apps/myapp/dynos/" <> dyno_name) do
    Poison.encode! %Dyno{@mydyno | name: dyno_name}
  end
  def get(_client, "/apps/" <> app_name) do
    Poison.encode! %App{@myapp | name: app_name}
  end
  def get(_client, "/account/rate-limits") do
    Poison.encode! %{remaining: 1234}
  end
end
