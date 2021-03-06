defmodule MapSchema.Macros.MutsTypes do
  @moduledoc false
  @doc """
  The muts module compone the macros that let us, build the methods mut:

  `mut_$field(map,fn(oldValue)-> ... newValue end)`

  """
  alias MapSchema.Types
  alias MapSchema.Utils

  def install(custom_types, lista_fields, type) do
    if Types.have_doctest?(custom_types, type)  do
      build_muts_with_doctest(custom_types, lista_fields, type)
    else
      build_muts(lista_fields, type)
    end
  end

  defp build_muts_with_doctest(custom_types, lista_fields, type) do
    field = Utils.get_field_name(lista_fields)

    {test_value, test_expected} = Types.get_doctest(custom_types, type)

    quote bind_quoted: [field: field,  type: type ,
    test_value: test_value ,  test_expected: test_expected] do
      name_function_get = String.to_atom("get_" <> field)
      name_function_put = String.to_atom("put_" <> field)
      name_function_mut = String.to_atom("mut_" <> field)
      @doc """
      mut the value of #{field} field,  using a `mut_fn.(actualValue)` that will recive the actual value.
      Before of update the valor will be check it.

      Remember that #{field} is #{type} type.
      ## Example:

            iex>obj = #{__MODULE__}.new()
            ...> |> #{__MODULE__}.mut_#{field}(fn(_old)-> #{test_value} end)
            iex> #{__MODULE__}.get_#{field}(obj)
            #{test_expected}

      """
      def unquote(name_function_mut)(var!(mapa), var!(mut_fn)) when is_map(var!(mapa)) do
        var!(muted_value) = var!(mapa)
          |> unquote(name_function_get)()
          |> var!(mut_fn).()

        unquote(name_function_put)(var!(mapa), var!(muted_value))
      end
      def unquote(name_function_mut)(_, _) do
        MapSchema.Exceptions.throw_error_should_be_a_map()
      end
    end
  end

  defp build_muts(lista_fields, type) do
    field = Utils.get_field_name(lista_fields)

    quote bind_quoted: [field: field,  type: type] do
      name_function_get = String.to_atom("get_" <> field)
      name_function_put = String.to_atom("put_" <> field)
      name_function_mut = String.to_atom("mut_" <> field)
      @doc """
      mut the value of #{field} field,  using a `mut_fn.(actualValue)` that will recive the actual value.
      Before of update the valor will be check it.

      Remember that #{field} is #{type} type.
      """
      def unquote(name_function_mut)(var!(mapa), var!(mut_fn)) when is_map(var!(mapa)) do
        var!(muted_value) = var!(mapa)
          |> unquote(name_function_get)()
          |> var!(mut_fn).()

        unquote(name_function_put)(var!(mapa), var!(muted_value))
      end
      def unquote(name_function_mut)(_, _) do
        MapSchema.Exceptions.throw_error_should_be_a_map()
      end
    end
  end

end
