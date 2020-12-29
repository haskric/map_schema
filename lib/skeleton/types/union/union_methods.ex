defmodule MapSchema.Types.TypeUnion.Methods do
  @moduledoc false
  def cast(value, list_types) do
    if is_valid?(value, list_types) do
      value
    else
      case cast_to_valid(value, list_types) do
        {true, cast_value} -> cast_value
        _ -> :map_schema_type_error
      end
    end
  end

  defp cast_to_valid(value, list_types) do
    list_types
    |> Enum.reduce({false, value}, fn(type_module, {flag, acc_cast_value}) ->
      if flag == true do
        {flag, acc_cast_value}
      else
        acc_cast_value = apply_cast(type_module, value)
        if apply_is_valid?(type_module, acc_cast_value) do
          {true, acc_cast_value}
        else
          {false, acc_cast_value}
        end
      end
    end)
  end

  defp apply_cast(type_module, value) do
    apply(type_module, :cast, [value])
  end

  def is_valid?(value, list_types) do
    list_types
    |> Enum.map(fn(type_module) ->
      apply_is_valid?(type_module, value)
    end)
    |> Enum.any?
  end

  defp apply_is_valid?(type_module, value) do
    apply(type_module, :is_valid?, [value])
  end

  def doctest_values(list_types) do
    list_types
    |> Enum.map(fn(type_module) ->
      apply_doctest_values(type_module)
    end)
    |> List.flatten()
  end

  defp apply_doctest_values(type_module) do
    apply(type_module, :doctest_values, [])
  end

end
