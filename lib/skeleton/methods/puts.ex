defmodule MapSchema.Methods.Puts do
  @moduledoc """
  The module have the internal functionality of the methods puts
  """

  alias MapSchema.DefaultTypes

  def generic_put(mapa, lista_fields, value) do
    mapa
    |> init_nested_maps(lista_fields)
    |> put_in(lista_fields, value)
  end

  def generic_put_with_typecheking(module, type, mapa, lista_fields, value) do
    module_custom_type = DefaultTypes.get_custom_type_module(module, type)
    case DefaultTypes.cast_value(module_custom_type, value) do
      :error -> throw "CASTING ERROR #{type}"
      after_cast_value ->
        if DefaultTypes.check_is_valid?(module_custom_type, after_cast_value) do
          mapa
          |> generic_put(lista_fields, after_cast_value)
        else
          throw "TYPE ERROR #{type}"
        end
    end
  end

  defp init_nested_maps(mapa, []) do
    mapa
  end
  defp init_nested_maps(mapa, [_field]) do
    mapa
  end
  defp init_nested_maps(mapa, lista_fields) do
    lista_fields
    |> Enum.drop(-1)
    |> Enum.reduce(mapa, fn(parent_field, acc_mapa)->
      if is_nil(Map.get(acc_mapa, parent_field)) do
        acc_mapa
        |> Map.put(parent_field, %{})
      else
        acc_mapa
      end
    end)
  end

end
