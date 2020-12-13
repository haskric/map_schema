defmodule MapSchema.DefaultTypes.MSchemaBool do
  @moduledoc """
  Bool type
  """
  @behaviour MapSchema.CustomType

  alias MapSchema.DefaultTypes.MSchemaBoolean

  @spec name :: atom
  def name, do: :bool
  def nested?, do: false

  @spec cast(any) :: any
  defdelegate cast(value), to: MSchemaBoolean

  @doc """
  Using is_boolean guard

  ## Examples

      iex> alias MapSchema.DefaultTypes.MSchemaBool
      iex> MSchemaBool.is_valid?(true)
      true

      iex> alias MapSchema.DefaultTypes.MSchemaBool
      iex> MSchemaBool.is_valid?("it isnt boolean")
      false

  """
  @spec is_valid?(any) :: boolean
  defdelegate is_valid?(value), to: MSchemaBoolean

  @spec doctest_values :: [{any, any}]
  defdelegate doctest_values, to: MSchemaBoolean

end
