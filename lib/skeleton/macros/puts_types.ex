defmodule MapSchema.PutsTypes do
  @moduledoc """
  The Puts module compone the macros that let us, build the methods put:

  - `put(map,field,value)`

  """
  alias MapSchema.Methods.Puts
  alias MapSchema.Utils
  alias MapSchema.DefaultTypes

  def install(custom_types, lista_fields, type) do

    if DefaultTypes.have_doctest?(custom_types, type)  do
      build_puts_with_doctest(custom_types, lista_fields, type)
    else
      build_puts(custom_types, lista_fields, type)
    end

  end

  defp build_puts_with_doctest(custom_types, lista_fields, type) do
    field = Utils.get_field_name(lista_fields)

    module_custom_type = DefaultTypes.get_custom_type_module(custom_types, type)
    {test_value, test_expected} = DefaultTypes.get_doctest(custom_types, type)

    quote bind_quoted: [module_custom_type: module_custom_type , field: field,  lista_fields: lista_fields, type: type,
    test_value: test_value, test_expected: test_expected ] do
      name_function = String.to_atom("put_" <> field)
      @doc """
      Put a new value in #{field} field.
      Before of update the valor will be check it.

      Remember that #{field} is #{type} type.

      ## Example:

            iex>obj = #{__MODULE__}.new()
            ...> |> #{__MODULE__}.put_#{field}(#{test_value})
            iex> #{__MODULE__}.get_#{field}(obj)
            #{test_expected}

      """
      def unquote(name_function)(var!(mapa), var!(value)) do
        #Puts.generic_put_with_typecheking(__MODULE__, unquote(type), var!(mapa), unquote(lista_fields), var!(value))

        Puts.generic_put_custom_type(unquote(module_custom_type), unquote(type), var!(mapa), unquote(lista_fields), var!(value))
      end
    end
  end

  defp build_puts(custom_types, lista_fields, type) do
    field = Utils.get_field_name(lista_fields)
    module_custom_type = DefaultTypes.get_custom_type_module(custom_types, type)

    quote bind_quoted: [module_custom_type: module_custom_type , field: field,  lista_fields: lista_fields, type: type] do
      name_function = String.to_atom("put_" <> field)
      @doc """
      Put a new value in #{field} field.
      Before of update the valor will be check it.

      Remember that #{field} is #{type} type.
      """
      def unquote(name_function)(var!(mapa), var!(value)) do
        #Puts.generic_put_with_typecheking(__MODULE__, unquote(type), var!(mapa), unquote(lista_fields), var!(value))
        Puts.generic_put_custom_type(unquote(module_custom_type), unquote(type), var!(mapa), unquote(lista_fields), var!(value))
      end
    end
  end

end
