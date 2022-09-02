defmodule NBP.Response do
  @moduledoc """
  Module responsible for wrapping responses from the API.
  """
  @type t :: %__MODULE__{
    body: binary(),
  }

  defstruct body: nil
end
