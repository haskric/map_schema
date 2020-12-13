defmodule MapSchema.Methods.PutPartialTypes do
  @moduledoc """
  The module have the internal functionality of the methods put_partial

  """
  alias MapSchema.Types
  alias MapSchema.Utils

  alias MapSchema.Methods.PutPartialTypes
  alias MapSchema.Exceptions

  defstruct module: nil,
            map: nil,
            map_update: nil,
            custom_types: nil,
            schema: nil,
            lista_fields: [],
            emit_exception: true

  def put(module, map, map_update, custom_types) do
    emit_exception = true
    action = action_contructor(module, map, map_update, custom_types, emit_exception)
    execute_put(action)
  end

  def put_ifmatch(module, map, map_update, custom_types) do
    emit_exception = false
    action = action_contructor(module, map, map_update, custom_types, emit_exception)
    execute_put(action)
  end

  defp action_contructor(module, map, map_update, custom_types, emit_exception) do
    schema = apply(module, :schema, [])

    %PutPartialTypes{
      module: module,
      map: map,
      map_update: map_update,
      custom_types: custom_types,
      schema: schema,
      lista_fields: [],
      emit_exception: emit_exception
    }
  end

  def execute_put(action) do
    action.map_update
    |> Map.keys()
    |> Enum.reduce(action.map, fn(field, acc_map) ->
      valor = get_in(action.map_update, [field])
      type = get_in(action.schema, [field])
      lista_fields = action.lista_fields ++ [field]

      cond do
        type == nil ->
          if action.emit_exception do
            Exceptions.throw_not_exist_field_in_schema(field)
          else
            acc_map
          end
        Types.is_flexible_nested?(action.custom_types, type) ->
          acc_map
          |> call_put_of_field(action.module, lista_fields, valor)
        is_map(type) ->
          sub_schema = get_in(action.schema, [field])
          sub_map_update = get_in(action.map_update, [field])

          action
          |> update_action(%{
            map: acc_map,
            schema: sub_schema,
            map_update: sub_map_update,
            lista_fields: lista_fields
          })
          |> execute_put()
        true ->
          acc_map
          |> call_put_of_field(action.module, lista_fields, valor)
      end
    end)
  end

  defp update_action(action, changes) do
    changes
    |> Map.keys()
    |> Enum.reduce(action, fn(key, acc_action) ->
      value = Map.get(changes, key)

      acc_action
      |> Map.put(key, value)
    end)
  end


  def put2(module, map, map_update, custom_types) do
    schema = apply(module, :schema, [])
    put(map, module, schema, map_update, custom_types, [])
  end
  defp put(map, module, schema, map_update, custom_types, lista_fields) do
    map_update
    |> Map.keys()
    |> Enum.reduce(map, fn(field, acc_map) ->
      valor = get_in(map_update, [field])
      type = get_in(schema, [field])
      lista_fields = lista_fields ++ [field]

      cond do
        type == nil ->
          throw("Error schema: the field " <> field <> " dont exit in schema")
        Types.is_flexible_nested?(custom_types, type) ->
          acc_map
          |> call_put_of_field(module, lista_fields, valor)
        is_map(type) ->
          sub_schema = get_in(schema, [field])
          sub_map_update = get_in(map_update, [field])

          acc_map
          |> put(module, sub_schema, sub_map_update, custom_types, lista_fields)
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
