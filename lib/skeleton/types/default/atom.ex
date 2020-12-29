defmodule MapSchema.DefaultTypes.MSchemaAtom do
  @moduledoc false
  @doc """
  atom type
  """
  @behaviour MapSchema.CustomType

  @spec name :: atom | String.t()
  def name, do: :atom
  def nested?, do: false

  @spec cast(value :: any) :: any | :map_schema_type_error
  def cast(value) when is_bitstring(value) do
   String.to_atom(value)
  end
  def cast(value) do
    value
  end

  @doc """
  Using is_atom guard

  ## Examples

      iex> alias MapSchema.DefaultTypes.MSchemaAtom
      iex> MSchemaAtom.is_valid?(:hi_atom)
      true

      iex> alias MapSchema.DefaultTypes.MSchemaAtom
      iex> MSchemaAtom.is_valid?(101010)
      false

  """
  @spec is_valid?(any) :: boolean
  def is_valid?(value) do
    is_atom(value)
  end

  @spec doctest_values :: [{any, any}]
  def doctest_values do
    [:hola, :hi_atom, :its_a_atom]
    |> Enum.map(fn(text) -> {text, text} end)
  end

end
