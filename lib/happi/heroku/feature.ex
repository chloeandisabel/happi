defmodule Happi.Heroku.Feature do
  @moduledoc """
  Heroku Feature.
  """

  @derive [Poison.Encoder]
  use Napper.Resource

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
    created_at: String.t,
    updated_at: String.t
  }
end

defimpl Napper.Endpoint, for: Happi.Heroku.Feature do
  def under_master_resource?(_), do: false
  def endpoint_url(_), do: "/account/features"
end
