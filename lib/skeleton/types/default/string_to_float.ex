defmodule MapSchema.DefaultTypes.MSchemaStringToFloat do
  @moduledoc false
  @doc """
  StringToFloat type
  """
  @behaviour MapSchema.CustomType

  alias MapSchema.ExuString

  @spec name :: atom | String.t()
  def name, do: :string_to_float
  def nested?, do: false

  @spec cast(value :: any) :: any | :map_schema_type_error
  def cast(value) do
    case ExuString.to_float!(value) do
      :error -> :map_schema_type_error
      cast_value -> cast_value
    end
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
