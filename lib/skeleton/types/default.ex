defmodule MapSchema.Types.Default do
  @moduledoc false
  alias MapSchema.Exceptions

  def get_default_type_module(type) do
    module = default_map()
      |> Map.get(type)

    if is_nil(module) do
      Exceptions.throw_error_type_dont_undefined(type)
    else
      module
    end
  end

  defp default_map do
    %{
      atom: MapSchema.DefaultTypes.MSchemaAtom,
      any: MapSchema.DefaultTypes.MSchemaAny,
      bool: MapSchema.DefaultTypes.MSchemaBool,
      boolean: MapSchema.DefaultTypes.MSchemaBoolean,
      float: MapSchema.DefaultTypes.MSchemaFloat,
      integer: MapSchema.DefaultTypes.MSchemaInteger,
      list: MapSchema.DefaultTypes.MSchemaList,
      map: MapSchema.DefaultTypes.MSchemaMap,
      keyword: MapSchema.DefaultTypes.MSchemaKeyword,
      string: MapSchema.DefaultTypes.MSchemaString,
      string_to_float: MapSchema.DefaultTypes.MSchemaStringToFloat,
      string_to_integer: MapSchema.DefaultTypes.MSchemaStringToInteger
    }
  end

end
