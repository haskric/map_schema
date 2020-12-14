defmodule MapSchema.DefaultTypes do
  @moduledoc """
  Default types
  """

  alias MapSchema.Exceptions
  alias MapSchema.DefaultTypes

  defstruct module: nil,
            type_name: nil,
            type_list_name: nil,
            list_custom_types: nil

  def param_config(module, type_name, type_list_name, list_custom_types) do
    {list_custom_types, []} =  Code.eval_quoted(list_custom_types)
    IO.inspect module
    {module, []} =  Code.eval_quoted(module)

    %DefaultTypes{
      module: module,
      type_name: type_name,
      type_list_name: type_list_name,
      list_custom_types: list_custom_types
    }
    |> param_config()
  end

  def param_config(config) do
    list_custom_types = config.list_custom_types

    cond do
      is_nil(list_custom_types) or list_custom_types == [] ->
        %{}
        |> add_recursive_types(config)
      is_list(list_custom_types) ->
        config
        |> build_map_custom_types()
        |> add_recursive_types(config)
      true ->
        Exceptions.throw_config_error_custom_types_should_be_list()
    end
  end

  defp update_list(config, list_custom_types) do
    config
    |> Map.put(:list_custom_types, list_custom_types)
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
      MapSchema.DefaultTypes.MSchemaAny,
      MapSchema.DefaultTypes.MSchemaStringToInteger,
      MapSchema.DefaultTypes.MSchemaStringToFloat
    ]
  end

  def default_map() do
    default_types()
    |> build_map_with_list()
  end

  #def build_map_custom_types do
  #  default_types()
  #  |> build_map_with_list()
  #end
  def build_map_custom_types(config) do
    IO.inspect config.list_custom_types

    result = config.list_custom_types
    |> remove_recursive_types_invalid()

    IO.inspect result
    #|> build_map_with_list()
    %{}
  end

  defp add_recursive_types(map_custom_types, config) do
    map_custom_types
    |> add_recursive_type_name(config)
    |> add_recursive_type_list_name(config)
  end

  defp add_recursive_type_list_name(map_custom_types, config) do
    case config.type_list_name do
      :not_deftype -> map_custom_types
      type_list_name ->
        module_type = "#{config.module}.TypeList"
          |> String.to_atom()

        map_custom_types
        |> Map.put(type_list_name, module_type)
    end
  end

  defp add_recursive_type_name(map_custom_types, config) do
    case config.type_name do
      :not_deftype -> map_custom_types
      type_name ->
        module_type = "#{config.module}.Type"
          |> String.to_atom()

        map_custom_types
        |> Map.put(type_name, module_type)
    end
  end

  defp remove_recursive_types_invalid(config) do
    list_invalids = list_invalid_types(config)
    IO.inspect list_invalids
    list_custom_types = config.list_custom_types -- list_invalids

    IO.inspect list_custom_types

    list_custom_types
  end

  defp list_invalid_types(config) do
    IO.puts "list_invalid_types"
    module = config.module

    IO.inspect module

    [
      "#{config.module}.Type",
      "#{config.module}.TypeList"
    ]
    |> Enum.map(fn(module) -> module |> String.to_atom() end)
  end

  defp build_map_with_list(list_custom_types) when is_list(list_custom_types) do
    IO.inspect list_custom_types

    list_custom_types
    |> Enum.reduce(%{}, fn(module, acc_map) ->
      key = apply(module, :name, [])

      acc_map
      |> Map.put(key, module)
    end)
  end

end
