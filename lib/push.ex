defmodule RavenxPusher.Push do
  @moduledoc """
  RavenxPusher.Push represents a `Push` being sent through `Pusher`.
  """

  defstruct data: nil,
            event: nil,
            channels: [],
            socket_id: nil,
            sent?: false

  @type t :: %__MODULE__{
    data: any,
    event: binary,
    socket_id: binary,
    channels: binary | list(binary),
    sent?: atom
  }
end