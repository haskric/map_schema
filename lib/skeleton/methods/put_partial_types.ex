defmodule MapSchema.Methods.PutPartialTypes do
  @moduledoc false
  @doc """
  The module have the internal functionality of the methods put_partial

  """
  alias MapSchema.Atomize
  alias MapSchema.Exceptions
  alias MapSchema.Methods.PutPartialTypes
  alias MapSchema.Types
  alias MapSchema.Utils

  defstruct module: nil,
            map: nil,
            map_update: nil,
            custom_types: nil,
            schema: nil,
            lista_fields: [],
            emit_exception: true,
            flag_atomize: false

  def put(module, map, map_update, custom_types, flag_atomize) when is_map(map) and is_map(map_update) do
    emit_exception = true
    action = action_contructor(module, map, map_update, custom_types, emit_exception, flag_atomize)
    execute_put(action)
  end
  def put(_module, _map, _map_update, _custom_types, _flag_atomize) do
    Exceptions.throw_error_should_be_a_map()
  end

  def put_ifmatch(module, map, map_update, custom_types, flag_atomize) when is_map(map) and is_map(map_update)  do
    emit_exception = false
    action = action_contructor(module, map, map_update, custom_types, emit_exception, flag_atomize)
    execute_put(action)
  end
  def put_ifmatch(_module, _map, _map_update, _custom_types, _flag_atomize) do
    Exceptions.throw_error_should_be_a_map()
  end

  defp action_contructor(module, map, map_update, custom_types, emit_exception, flag_atomize) do
    schema = apply(module, :schema, [])

    %PutPartialTypes{
      module: module,
      map: map,
      map_update: map_update,
      custom_types: custom_types,
      schema: schema,
      lista_fields: [],
      emit_exception: emit_exception,
      flag_atomize: flag_atomize
    }
  end

  def execute_put(action) do
    action.map_update
    |> Map.keys()
    |> Enum.reduce(action.map, fn(upmap_field, acc_map) ->
      field = Atomize.process_field(upmap_field, action.flag_atomize)

      valor = get_in(action.map_update, [upmap_field])
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
          sub_map_update = get_in(action.map_update, [upmap_field])

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

  defp call_put_of_field(acc_map, module, lista_fields, valor) do
    name_field = Utils.get_field_name(lista_fields)
    name_function = String.to_atom("put_" <> name_field)
    apply(module, name_function, [acc_map, valor])
  end

end
