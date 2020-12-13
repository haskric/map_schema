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


  def execute_autocast_typechecking(module_custom_type, value) do
    case cast_value(module_custom_type, value) do
      :error -> {:error_cast, nil}
      after_cast_value ->
        if check_is_valid?(module_custom_type, after_cast_value) do
          {:ok, after_cast_value}
        else
          {:error_type, nil}
        end
    end
  end


  def get_custom_type_module(custom_types, type) when is_map(custom_types) do
    custom_types
    |> Map.get(type)
  end
  def get_custom_type_module(module, type) do
    apply(module, :schema_get_type_module, [type])
  end

  def cast_value(nil, value), do: value
  def cast_value(module_custom_type, value) do
    apply(module_custom_type , :cast, [value])
  end

  def check_is_valid?(nil, _after_cast_value), do: true
  def check_is_valid?(:error, _after_cast_value), do: false
  def check_is_valid?(module_custom_type, after_cast_value) do
    apply(module_custom_type , :is_valid?, [after_cast_value])
  end

  def have_doctest?(custom_types, type) do
    get_doctest(custom_types, type) != :error
  end

  def get_doctest(custom_types, type) when is_map(custom_types) do
    module_custom_type = get_custom_type_module(custom_types, type)

    if is_nil(module_custom_type) do
      :error
    else
      module_custom_type
      |> apply(:doctest_values, [])
      |> choise_random_test()
    end
  end

  defp choise_random_test(set_tests) do
    set_tests
    |> Enum.take_random(1)
    |> hd
  end



  @doc """
  The field of schema can save flexible content, if the user say that it use
  a :map, :list, or any custom type. In this cases we wont check the type of data.

  """
  def is_flexible_nested?(_custom_types, type) when is_map(type) do
    false
  end
  def is_flexible_nested?(custom_types, type) do
    case get_custom_type_module(custom_types, type) do
      nil -> false
      module_custom_type ->
        apply(module_custom_type, :nested?, [])
    end
  end


end
