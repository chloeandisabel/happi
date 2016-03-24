defmodule Happi.Heroku.Feature do
  
  @moduledoc """
  Heroku Feature.
  """

  @derive [Poison.Encoder]

  defstruct id: "",
    name: "",
    description: "",
    doc_url: "",
    enabled: false,
    state: "",
    created_at: nil,
    updated_at: nil

  @doc """
  Return a list containing all of your features.
  """
  def list(client) do
    client
    |> Happi.API.get("/account/features")
    |> Poison.decode!(as: [%Happi.Heroku.Feature{}])
  end

  @doc """
  Returns a specific feature.
  """
  def get(client, feature_name_or_id) do
    client
    |> Happi.API.get("/account/features/#{feature_name_or_id}")
    |> Poison.decode!(as: %Happi.Heroku.Feature{})
  end

  def update(client, feature) do
    client
    |> Happi.API.patch("account/features/#{feature.id}",
                       Poison.encode!(feature))
  end
end
