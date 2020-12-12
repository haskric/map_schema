defmodule MapSchema.Methods.PutPartial do
  @moduledoc """
  The module have the internal functionality of the methods put_partial

  """
  alias MapSchema.Utils

  def put(module, map, map_update) do
    schema = apply(module, :schema, [])
    put(map, module, schema, map_update, [])
  end
  defp put(map, module, schema, map_update, lista_fields) do
    map_update
    |> Map.keys()
    |> Enum.reduce(map, fn(field, acc_map) ->
      valor = get_in(map_update, [field])
      type = get_in(schema, [field])
      lista_fields = lista_fields ++ [field]

      cond do
        type == nil ->
          throw("Error schema: the field " <> field <> " dont exit in schema")
        Utils.is_flexible_nested?(type) ->

          acc_map
          |> call_put_of_field(module, lista_fields, valor)
        is_map(type) ->
          sub_schema = get_in(schema, [field])
          sub_map_update = get_in(map_update, [field])

          acc_map
          |> put(module, sub_schema, sub_map_update, lista_fields)
        true ->
          acc_map
          |> call_put_of_field(module, lista_fields, valor)
      end
    end)
  end

  defp call_put_of_field(acc_map, module, lista_fields, valor) do
    name_field = Utils.get_field_name(lista_fields)
    name_function = String.to_atom("put_" <> name_field)
    apply(module, name_function, [acc_map, valor])
  end

end
