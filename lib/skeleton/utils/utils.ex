defmodule MapSchema.Utils do
  @moduledoc """
  The module have the utils functions.
  """

  alias MapSchema.Utils.Testing

  @doc """
  Take list of fields and build a full name.
  """
  def get_field_name(lista_fields) do
    lista_fields |> Enum.join("_")
  end

  @doc """
  Take a type of data and return the guard that we need use for check the value.
  """
  def get_guard_by_type(type) do
    case type do
      :string_to_integer -> :is_integer
      :string_to_float -> :is_float
      :integer -> :is_integer
      :float -> :is_float
      :string -> :is_bitstring
      :bool -> :is_boolean
      :boolean -> :is_boolean
      :map -> :is_map
      :list -> :is_list
      :any -> nil
      _ -> nil
    end
  end

  @doc """
  The field of schema can save flexible content, if the user say that it use
  a :map, :list, or any custom type. In this cases we wont check the type of data.

  """
  def is_flexible_nested?(type) when is_map(type) do
    false
  end
  def is_flexible_nested?(type) do
    case get_guard_by_type(type) do
      nil -> true
      :is_map -> true
      :is_list -> true
      _ -> false
    end
  end

  @doc """
  Take a type of data and returns a tuple `{testing_value, testing_result}` with the example values
  that we used in doctest.
  """
  def build_test_values(type) do
    Testing.generate_random_test_value(type)
  end

end
