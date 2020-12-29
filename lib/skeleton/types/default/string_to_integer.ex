defmodule MapSchema.DefaultTypes.MSchemaStringToInteger do
  @moduledoc false
  @doc """
  StringToInteger type
  """
  @behaviour MapSchema.CustomType

  alias MapSchema.ExuString

  @spec name :: atom | String.t()
  def name, do: :string_to_integer
  def nested?, do: false

  @spec cast(any) :: any
  def cast(value) do
    ExuString.to_integer!(value)
  end

  @doc """
  Using is_integer guard
  -> 1. Will be execute cast(value)

  ## Examples

      iex> alias MapSchema.DefaultTypes.MSchemaStringToInteger
      iex> MSchemaStringToInteger.cast("10203")
      iex> |> MSchemaStringToInteger.is_valid?()
      true

      iex> alias MapSchema.DefaultTypes.MSchemaStringToInteger
      iex> MSchemaStringToInteger.cast("it´s a integer")
      iex> |> MSchemaStringToInteger.is_valid?()
      false

  """
  @spec is_valid?(any) :: boolean

  # It´s unecessary but I add help undestand it.
  def is_valid?(:error), do: false
  def is_valid?(value) do
    is_integer(value)
  end

  @spec doctest_values :: [{any, any}]
  def doctest_values do
    ["1", "5", "10", "20", "30", "40", "50"]
    |> Enum.map(fn(text) -> {"\"#{text}\"", text} end)
  end

end
