defmodule Happi.Heroku.Key do
  
  @moduledoc """
  Heroku key.
  """
  
  @derive [Poison.Encoder]

  defstruct id: "",
    public_key: "",
    email: "",
    fingerprint: "",
    comment: "",
    updated_at: nil,
    created_at: nil

  def list(client) do
    client
    |> Happi.API.get("/account/keys")
    |> Poison.decode!(as: [%Happi.Heroku.Key{}])
  end      

  def get(client, id_or_fingerprint) do
    client
    |> Happi.API.get("/account/keys/#{id_or_fingerprint}")
    |> Poison.decode!(as: %Happi.Heroku.Key{})
  end      

  def create(client, public_key) do
    client
    |> Happi.API.post("/account/keys",
                      Poison.encode!(%{public_key: public_key}))
    |> Poison.decode!(as: %Happi.Heroku.Key{})
  end

  def delete(client, id_or_fingerprint) do
    client
    |> Happi.API.delete("/account/keys/#{id_or_fingerprint}")
    |> Poison.decode!(as: %Happi.Heroku.Key{})
  end      
end
