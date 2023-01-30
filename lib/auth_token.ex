defmodule ExMeetSelectApi.AuthToken do
  @enforce_keys [:refresh, :access, :user]
  defstruct [:refresh, :access, :user]

  @type t :: %__MODULE__{
          refresh: String.t(),
          access: String.t(),
          user: any()
        }

  @spec new(String.t(), String.t(), any()) :: t()
  def new(refresh, access, user), do: %__MODULE__{refresh: refresh, access: access, user: user}

  @spec new(map()) :: t()
  def new(map), do: struct(__MODULE__, map)
end
