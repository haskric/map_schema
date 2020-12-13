defmodule MapSchema.DefaultTypes do
  @moduledoc """
  Default types
  """

  def param_config(list_custom_types) do
    {list_custom_types, []} =  Code.eval_quoted(list_custom_types)

    cond do
      is_nil(list_custom_types) ->
        build_map_custom_types()
      is_list(list_custom_types) ->
        list_custom_types
        |> build_map_custom_types()
      true ->
        throw "CUSTOM TYPES SHOULD BE A MAP OR NIL"
    end
  end

  def default_types do
    [
      MapSchema.DefaultTypes.MSchemaFloat,
      MapSchema.DefaultTypes.MSchemaInteger,
      MapSchema.DefaultTypes.MSchemaString,
      MapSchema.DefaultTypes.MSchemaBoolean,
      MapSchema.DefaultTypes.MSchemaBool,
      MapSchema.DefaultTypes.MSchemaMap,
      MapSchema.DefaultTypes.MSchemaList,
      MapSchema.DefaultTypes.MSchemaStringToInteger,
      MapSchema.DefaultTypes.MSchemaStringToFloat
    ]
  end


  def build_map_custom_types do
    build_map_custom_types([])
  end
  def build_map_custom_types(list_custom_types) when is_list(list_custom_types) do
    default_types() ++ list_custom_types
    |> Enum.reduce(%{}, fn(module, acc_map) ->
      key = apply(module, :name, [])

      acc_map
      |> Map.put(key, module)
    end)
  end




end
