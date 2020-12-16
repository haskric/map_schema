defmodule MapSchema.Macros.Gets do
  @moduledoc false
  @doc """
  The Gets module compone the macros that let us, build the methods get:

  - `get(map)`

  """

  alias MapSchema.Methods.Gets
  alias MapSchema.Utils

  def install(lista_fields, type) do
    build_getters(lista_fields, type)
  end

  defp build_getters(lista_fields, type) do
    field = Utils.get_field_name(lista_fields)
    quote bind_quoted: [field: field, lista_fields: lista_fields, type: type] do
      name_function = String.to_atom("get_" <> field)
      @doc """
      Get #{field} value of #{type} type.
      """
      def unquote(name_function)(var!(mapa)) when is_map(var!(mapa)) do
        var!(mapa)
        |> Gets.generic_get(unquote(lista_fields))
      end
      def unquote(name_function)(_) do
        MapSchema.Exceptions.throw_error_should_be_a_map()
      end
    end
  end

end
