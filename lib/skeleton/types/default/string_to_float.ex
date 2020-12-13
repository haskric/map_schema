defmodule MapSchema.DefaultTypes.MSchemaStringToFloat do
  @moduledoc """
  StringToFloat type
  """
  @behaviour MapSchema.CustomType

  alias MapSchema.ExuString

  @spec name :: atom
  def name, do: :string_to_float
  def nested?, do: false

  @spec cast(any) :: any
  def cast(value) do
    ExuString.to_float!(value)
  end

  @doc """
  Using is_float guard
  -> 1. Will be execute cast(value)

  ## Examples

      iex> alias MapSchema.DefaultTypes.MSchemaStringToFloat
      iex> MSchemaStringToFloat.cast("102.332")
      iex> |> MSchemaStringToFloat.is_valid?()
      true

      iex> alias MapSchema.DefaultTypes.MSchemaStringToFloat
      iex> MSchemaStringToFloat.cast("it´s a float")
      iex> |> MSchemaStringToFloat.is_valid?()
      false

  """
  @spec is_valid?(any) :: boolean

  # It´s unecessary but I add help undestand it.
  def is_valid?(:error), do: false
  def is_valid?(value) do
    is_float(value)
  end

  @spec doctest_values :: [{any, any}]
  def doctest_values do
    ["1.25", "4.54", "3.593", "11.294", "123.45"]
    |> Enum.map(fn(text) -> {"\"#{text}\"", text} end)
  end

end
