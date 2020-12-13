defmodule MapSchema.Methods.Puts do
  @moduledoc """
  The module have the internal functionality of the methods puts
  """

  alias MapSchema.Exceptions
  alias MapSchema.Types
  alias MapSchema.Utils




  def generic_put_custom_type(module_custom_type, type, mapa, lista_fields, value) do
    case Types.execute_autocast_typechecking(module_custom_type, value) do
      {:ok, after_cast_value} ->
        mapa
        |> generic_put(lista_fields, after_cast_value)
      {:error_cast, _} ->
        Utils.get_field_name(lista_fields)
        |> Exceptions.throw_cast_error(type)
      {:error_type, _} ->
        Utils.get_field_name(lista_fields)
        |> Exceptions.throw_type_error(type)
    end
  end


  defp generic_put(mapa, lista_fields, value) do
    mapa
    |> init_nested_maps(lista_fields)
    |> put_in(lista_fields, value)
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
    |> Enum.reduce(mapa, fn(parent_field, acc_mapa) ->
      if is_nil(Map.get(acc_mapa, parent_field)) do
        acc_mapa
        |> Map.put(parent_field, %{})
      else
        acc_mapa
      end
    end)
  end

end
