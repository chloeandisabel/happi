defmodule Happi.Heroku.App do
  
  @moduledoc """
  Heroku Application.
  """

  @derive [Poison.Encoder]

  defstruct id: "",
    name: "app",
    buildpack_provided_description: "",
    create_status: "",
    domain_name: %Happi.Heroku.DomainName{},
    dynos: 0,
    git_url: "https://git.heroku.com/chloeandisabel/fake.git",
    owner_delinquent: false,
    owner_email: "foo@example.com",
    owner_name: nil,
    region: "us",
    repo_migrate_status: "",
    repo_size: 0,
    requested_stack: nil,
    slug_size: 0,
    space: 0,
    stack: 0,
    web_url: nil,
    workers: 0,
    released_at: nil,
    archived_at: nil,
    created_at: nil,
    updated_at: nil

  @doc """
  Return a list containing all of your apps.
  """
  def list(client) do
    client
    |> Happi.API.get("/apps")
    |> Poison.decode!(as: [%Happi.Heroku.App{}])
  end

  @doc """
  Returns the client's app. If you want to get another app, create another
  client.
  """
  def get(client) do
    client.app
  end      

  @doc """
  Only used by Happi to grab the app initially. Everybody else should call
  `get/1`.

  `client` will contain base_url and key but, hopefully unsurprisingly, no
  app.
  """
  def initial_get(client, app_name_or_id) do
    client
    |> Happi.API.get("/apps/#{app_name_or_id}")
    |> Poison.decode!(as: %Happi.Heroku.App{})
  end
end
