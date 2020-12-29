defmodule MapSchema.DefaultTypes.MSchemaInteger do
  @moduledoc false
  @doc """
  Integer type
  """
  @behaviour MapSchema.CustomType

  @spec name :: atom | String.t()
  def name, do: :integer
  def nested?, do: false

  @spec cast(any) :: any
  def cast(value) do
    value
  end

  @doc """
  Using is_integer guard

  ## Examples

      iex> alias MapSchema.DefaultTypes.MSchemaInteger
      iex> MSchemaInteger.is_valid?(1)
      true

      iex> alias MapSchema.DefaultTypes.MSchemaInteger
      iex> MSchemaInteger.is_valid?("a")
      false

  """
  @spec is_valid?(any) :: boolean
  def is_valid?(value) do
    is_integer(value)
  end

  @spec doctest_values :: [{any, any}]
  def doctest_values do
    [1, 5, 10, 20, 30, 40, 50]
    |> Enum.map(fn(item) -> {item, item} end)
  end

end
