defmodule MapSchema.DefaultTypes.MSchemaString do
  @moduledoc false
  @doc """
  String type
  """
  @behaviour MapSchema.CustomType

  @spec name :: atom | String.t()
  def name, do: :string
  def nested?, do: false

  @spec cast(value :: any) :: any | :map_schema_type_error
  def cast(value) do
    value
  end

  @doc """
  Using is_bitstring guard

  ## Examples

      iex> alias MapSchema.DefaultTypes.MSchemaString
      iex> MSchemaString.is_valid?("hola mundo")
      true

      iex> alias MapSchema.DefaultTypes.MSchemaString
      iex> MSchemaString.is_valid?(101010)
      false

  """
  @spec is_valid?(any) :: boolean
  def is_valid?(value) do
    is_bitstring(value)
  end

  @spec doctest_values :: [{any, any}]
  def doctest_values do
    ["Madrid", "Barcelona", "Santiago", "Galicia", "Sevilla", "Santander"]
    |> Enum.map(fn(text) -> {"\"#{text}\"", "\"#{text}\""} end)
  end

end
