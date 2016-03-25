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

  @type t :: %__MODULE__{
    id: String.t,
    name: String.t,
    description: String.t,
    doc_url: String.t,
    enabled: boolean,
    state: String.t,
    created_at: String.t,       # TODO datetime
    updated_at: String.t        # TODO datetime
  }

  @doc """
  Return a list containing all of your features.
  """
  @spec list(Happi.t) :: [t]
  def list(client) do
    client
    |> Happi.API.get("/account/features")
    |> Poison.decode!(as: [%__MODULE__{}])
  end

  @doc """
  Returns a specific feature.
  """
  @spec get(Happi.t, String.t) :: t
  def get(client, feature_name_or_id) do
    client
    |> Happi.API.get("/account/features/#{feature_name_or_id}")
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec update(Happi.t, t) :: t
  def update(client, feature) do
    client
    |> Happi.API.patch("account/features/#{feature.id}",
                       Poison.encode!(feature))
  end
end
