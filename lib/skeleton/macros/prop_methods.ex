defmodule MapSchema.PropMethods do
  @moduledoc """
  The PropMethods module install for each field the macros `gets`, `puts` and `alter`
  """

  alias MapSchema.Gets
  alias MapSchema.Muts
  alias MapSchema.PutsTypes
  alias MapSchema.Puts

  def install(schema) do
    {my_schema, []} =  Code.eval_quoted(schema)
    if is_map(my_schema) do
      installing_getters_and_setters(my_schema, [])
    else
      throw "SCHEMA SHOULD BE A MAP"
    end
  end

  defp installing_getters_and_setters(my_schema, lista_fields) do
    Map.keys(my_schema)
    |> Enum.map(fn(field) ->
      type = get_in(my_schema, [field])
      lista_fields = lista_fields ++ [field]

      if is_map(type) do
        sub_schema = type
        installing_getters_and_setters(sub_schema, lista_fields)
      else
        getters = Gets.install(lista_fields, type)
        #puts = Puts.install(lista_fields, type)

        puts = PutsTypes.install(lista_fields, type)
        muts = Muts.install(lista_fields, type)

        [getters, puts, muts]
      end
    end)
    |> List.flatten()
  end

end
