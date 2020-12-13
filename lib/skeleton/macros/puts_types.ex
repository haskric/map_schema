defmodule MapSchema.PutsTypes do
  @moduledoc """
  The Puts module compone the macros that let us, build the methods put:

  - `put(map,field,value)`

  """
  alias MapSchema.Methods.Puts
  alias MapSchema.Utils
  alias MapSchema.DefaultTypes

  def install(lista_fields, type) do
    build_puts(lista_fields, type)
  end

  defp build_puts(lista_fields, type) do
    field = Utils.get_field_name(lista_fields)

    #{testing_value, testing_expected} = DefaultTypes.get_doctest(__MODULE__, type)

    #IO.inspect testing_value

    quote bind_quoted: [field: field,  lista_fields: lista_fields, type: type] do
      name_function = String.to_atom("put_" <> field)
      @doc """
      Put a new value in #{field} field.
      Put a new value in #{field} field.
      Before of update the valor will be check it.

      Remember that #{field} is #{type} type.


      """
      def unquote(name_function)(var!(mapa), var!(value)) do
        Puts.generic_put_with_typecheking(__MODULE__, unquote(type), var!(mapa), unquote(lista_fields), var!(value))
      end
    end
  end

end
