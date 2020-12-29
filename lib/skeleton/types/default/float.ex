defmodule MapSchema.DefaultTypes.MSchemaFloat do
  @moduledoc false
  @doc """
  Float type
  """
  @behaviour MapSchema.CustomType

  @spec name :: atom | String.t()
  def name, do: :float
  def nested?, do: false

  @spec cast(value :: any) :: any | :map_schema_type_error
  def cast(value) do
    value
  end

  @doc """
  Using is_float guard

  ## Examples

      iex> alias MapSchema.DefaultTypes.MSchemaFloat
      iex> MSchemaFloat.is_valid?(1.2)
      true

      iex> alias MapSchema.DefaultTypes.MSchemaFloat
      iex> MSchemaFloat.is_valid?(1)
      false

  """
  @spec is_valid?(any) :: boolean
  def is_valid?(value) do
    is_float(value)
  end

  @spec doctest_values :: [{any, any}]
  def doctest_values do
    [1.25, 4.54, 3.593, 11.294, 123.45]
    |> Enum.map(fn(item) -> {item, item} end)
  end

end
