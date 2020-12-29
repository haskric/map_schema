defmodule MapSchema.DefaultTypes.MSchemaKeyword do
  @moduledoc false

  @behaviour MapSchema.CustomType

  @spec name :: atom | String.t()
  def name, do: :keyword
  def nested?, do: true

  @spec cast(any) :: any
  def cast(value) do
    value
  end

  @doc """

  ## Example
    iex> alias MapSchema.DefaultTypes.MSchemaKeyword
    ...> MSchemaKeyword.cast([{:key,"value"}])
    ...> |> MSchemaKeyword.is_valid?()
    true

    # Without { key, value }
    iex> alias MapSchema.DefaultTypes.MSchemaKeyword
    ...> MSchemaKeyword.cast([:key,"value"])
    ...> |> MSchemaKeyword.is_valid?()
    false

  """
  @spec is_valid?(any) :: boolean
  def is_valid?(value) do
    Keyword.keyword?(value)
  end

  @spec doctest_values :: [{any, any}]
  def doctest_values do
    ["[{:hola,\"hi\"}]"]
    |> Enum.map(fn(item) -> {item, item} end)
  end

end
