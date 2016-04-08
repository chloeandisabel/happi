defmodule Happi.Heroku.Invitation do
  
  @moduledoc """
  Heroku invitation.

  Only the `Happi.get` endpoint is useful. For all other interactions, use
  the methods in this module.
  """

  alias Happi.Heroku.User

  @derive [Poison.Encoder]
  
  defstruct user: %User{},
    created_at: nil

  @type t :: %__MODULE__{
    user: User.t,
    created_at: String.t
  }

  @spec invite(Happi.t, String.t, String.t) :: t
  def invite(client, email, name \\ nil) do
    client
    |> Happi.API.post("/invitations",
                      Poison.encode!(%{email: email, name: name}))
    |> Poison.decode!(as: %__MODULE__{})
  end

  @spec finalize(Happi.t, String.t, String.t, boolean) :: t
  def finalize(client, token, password, receive_newsletter \\ false) do
    client
    |> Happi.API.patch("/invitations/#{token}",
                       Poison.encode!(%{password: password,
                                        password_confirmation: password,
                                        receive_newsletter: receive_newsletter}))
    |> Poison.decode!(as: %__MODULE__{})
  end
end

defimpl Happi.Endpoint, for: Happi.Heroku.Invitation do
  def endpoint_url(_), do: "/invitations"
  def app?(_), do: false
end
