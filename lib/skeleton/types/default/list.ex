defmodule MapSchema.DefaultTypes.MSchemaList do
  @moduledoc false
  @doc """
  List type
  """
  @behaviour MapSchema.CustomType

  @spec name :: atom | String.t()
  def name, do: :list
  def nested?, do: true

  @spec cast(value :: any) :: any | :map_schema_type_error
  def cast(value) do
    value
  end

  @doc """
  Using is_list guard

  ## Examples

      iex> alias MapSchema.DefaultTypes.MSchemaList
      iex> MSchemaList.is_valid?(["1","2"])
      true

      iex> alias MapSchema.DefaultTypes.MSchemaList
      iex> MSchemaList.is_valid?("it isnt list")
      false

  """
  @spec is_valid?(any) :: boolean
  def is_valid?(value) do
    is_list(value)
  end

  @spec doctest_values :: [{any, any}]
  def doctest_values do
    ["[1, 5, 10]", "[1.25, 4.54, 3.593]"]
    |> Enum.map(fn(item) -> {item, item} end)
  end

end
