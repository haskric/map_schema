defmodule MapSchema.DefaultTypes.MSchemaBoolean do
  @moduledoc false
  @doc """
  Boolean type
  """
  @behaviour MapSchema.CustomType

  @spec name :: atom | String.t()
  def name, do: :boolean
  def nested?, do: false

  @spec cast(any) :: any
  def cast(value) do
    value
  end

  @doc """
  Using is_boolean guard

  ## Examples

      iex> alias MapSchema.DefaultTypes.MSchemaBoolean
      iex> MSchemaBoolean.is_valid?(true)
      true

      iex> alias MapSchema.DefaultTypes.MSchemaBoolean
      iex> MSchemaBoolean.is_valid?("it isnt boolean")
      false

  """
  @spec is_valid?(any) :: boolean
  def is_valid?(value) do
    is_boolean(value)
  end

  @spec doctest_values :: [{any, any}]
  def doctest_values do
    [true, false]
    |> Enum.map(fn(item) -> {item, item} end)
  end

end
