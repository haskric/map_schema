defmodule MapSchema.DefaultTypes.MSchemaMap do
  @moduledoc false
  @doc """
  Map type
  """
  @behaviour MapSchema.CustomType

  @spec name :: atom
  def name, do: :map
  def nested?, do: true

  @spec cast(any) :: any
  def cast(value) do
    value
  end

  @doc """
  Using is_map guard

  ## Examples

      iex> alias MapSchema.DefaultTypes.MSchemaMap
      iex> MSchemaMap.is_valid?(%{ a: "1"})
      true

      iex> alias MapSchema.DefaultTypes.MSchemaMap
      iex> MSchemaMap.is_valid?("it isnt a map")
      false

  """
  @spec is_valid?(any) :: boolean
  def is_valid?(value) do
    is_map(value)
  end

  @spec doctest_values :: [{any, any}]
  def doctest_values do
    ["%{example_field: 11}",  "%{ field0: 0,  field1: 1}"]
    |> Enum.map(fn(item) -> {item, item} end)
  end

end
