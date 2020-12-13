defmodule MapSchema.DefaultTypes.MSchemaAny do
  @moduledoc """
  Any type
  """
  @behaviour MapSchema.CustomType

  @spec name :: atom
  def name, do: :any
  def nested?, do: true

  @spec cast(any) :: any
  def cast(value) do
    value
  end

  @doc """
  Always true

  ## Examples

      iex> alias MapSchema.DefaultTypes.MSchemaAny
      iex> MSchemaAny.is_valid?(["1","2"])
      true

      iex> alias MapSchema.DefaultTypes.MSchemaAny
      iex> MSchemaAny.is_valid?("always is anything")
      true

  """
  @spec is_valid?(any) :: boolean
  def is_valid?(_value) do
    true
  end

  @spec doctest_values :: [{any, any}]
  def doctest_values do
    ["\"its_anything\""]
    |> Enum.map(fn(item) -> {item, item} end)
  end

end
