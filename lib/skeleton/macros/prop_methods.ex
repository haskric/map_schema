defmodule MapSchema.PropMethods do
  @moduledoc """
  The PropMethods module install for each field the macros `gets`, `puts` and `alter`
  """

  alias MapSchema.Gets
  #alias MapSchema.Muts
  alias MapSchema.MutsTypes
  alias MapSchema.PutsTypes

  def install(schema, custom_types) do
    case get_param_schema(schema) do
      :error -> throw "SCHEMA SHOULD BE A MAP"
      my_schema ->
        installing_getters_and_setters(my_schema, custom_types, [])
    end
  end

  defp get_param_schema(schema) do
    {my_schema, []} =  Code.eval_quoted(schema)
    if is_map(my_schema) do
      my_schema
    else
      :error
    end
  end

  defp installing_getters_and_setters(my_schema, custom_types, lista_fields) do
    Map.keys(my_schema)
    |> Enum.map(fn(field) ->
      type = get_in(my_schema, [field])
      lista_fields = lista_fields ++ [field]

      if is_map(type) do
        sub_schema = type
        installing_getters_and_setters(sub_schema, custom_types, lista_fields)
      else
        getters = Gets.install(lista_fields, type)
        puts = PutsTypes.install(custom_types, lista_fields, type )
        muts = MutsTypes.install(custom_types, lista_fields, type )

        [getters, puts, muts]
      end
    end)
    |> List.flatten()
  end

end
