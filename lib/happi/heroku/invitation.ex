defmodule Happi.Heroku.Invitation do
  
  @moduledoc """
  Heroku invitation.
  """

  @derive [Poison.Encoder]
  
  defstruct user: %Happi.Heroku.User{},
    created_at: nil

  def invite(client, email, name \\ nil) do
    client
    |> Happi.API.post("/invitations",
                      Poison.encode!(%{email: email, name: name}))
    |> Poison.decode!(as: %Happi.Heroku.Invitation{})
  end

  def get(client, token) do
    client
    |> Happi.API.get("/invitations/#{token}")
    |> Poison.decode!(as: %Happi.Heroku.Invitation{})
  end

  def finalize(client, token, password, receive_newsletter \\ false) do
    client
    |> Happi.API.patch("/invitations/#{token}",
                       Poison.encode!(%{password: password,
                                        password_confirmation: password,
                                        receive_newsletter: receive_newsletter}))
    |> Poison.decode!(as: %Happi.Heroku.Invitation{})
  end
end
