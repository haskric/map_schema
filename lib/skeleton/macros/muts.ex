defmodule MapSchema.Muts do
  @moduledoc """
  The muts module compone the macros that let us, build the methods mut:

  `mut_$field(map,fn(oldValue)-> ... newValue end)`

  """
  alias MapSchema.Utils

  def install(lista_fields, type) do
    build_muts(lista_fields, type)
  end

  defp build_muts(lista_fields, nil)  do
    build_muts(lista_fields, :any)
  end
  defp build_muts(lista_fields, type) when is_map(type) do
    build_muts(lista_fields, :map)
  end
  defp build_muts(lista_fields, :string_to_integer) do
    build_muts_cast(lista_fields, :string_to_integer)
  end
  defp build_muts(lista_fields, :string_to_float) do
    build_muts_cast(lista_fields, :string_to_float)
  end

  defp build_muts_cast(lista_fields, type) do
    field = Utils.get_field_name(lista_fields)
    guard = Utils.get_guard_by_type(type)

    {testing_value, result_testing} = Utils.build_test_values(type)

    quote bind_quoted: [field: field,  type: type ,
    testing_value: testing_value ,  result_testing: result_testing,  guard: guard] do
      name_function_get = String.to_atom("get_" <> field)
      name_function_put = String.to_atom("put_" <> field)
      name_function_mut = String.to_atom("mut_" <> field)
      cast_function_check = "#{guard}!" |> String.replace("is_", "to_") |> String.to_atom()
      @doc """
      mut the value of #{field} field,  using a `mut_fn.(actualValue)` that will recive the actual value.
      Before of update the valor will be check it.

      Remember that #{field} is #{type} type.
      ## Example:

            iex>obj = #{__MODULE__}.new()
            ...> |> #{__MODULE__}.mut_#{field}(fn(_old)-> #{testing_value} end)
            iex> #{__MODULE__}.get_#{field}(obj)
            #{result_testing}

      """
      def unquote(name_function_mut)(var!(mapa), var!(mut_fn)) do
        var!(value) = var!(mapa)
          |> unquote(name_function_get)()
          |> var!(mut_fn).()

        case apply(Elixir.MapSchema.ExuString, unquote(cast_function_check), [var!(value)]) do
          :error ->
            throw("Error cast #{unquote(field)}")
          var!(num) ->
            unquote(name_function_put)(var!(mapa), var!(num))
        end
      end
    end
  end

  defp build_muts(lista_fields, type) do
    field = Utils.get_field_name(lista_fields)

    {testing_value, _} = Utils.build_test_values(type)

    quote bind_quoted: [field: field,  type: type ,  testing_value: testing_value ] do
      name_function_get = String.to_atom("get_" <> field)
      name_function_put = String.to_atom("put_" <> field)
      name_function_mut = String.to_atom("mut_" <> field)

      @doc """
      Change the value of #{field} field, using a `mut_fn.(actualValue)` that will recive the actual value.
      Before of update the valor will be check it.

      Remember that #{field} is #{type} type.
      ## Example:

            iex>obj = #{__MODULE__}.new()
            ...> |> #{__MODULE__}.mut_#{field}(fn(_old)-> #{testing_value} end)
            iex> #{__MODULE__}.get_#{field}(obj)
            #{testing_value}

      """
      def unquote(name_function_mut)(var!(mapa), var!(mut_fn)) do
        var!(value) = var!(mapa)
          |> unquote(name_function_get)()
          |> var!(mut_fn).()

        unquote(name_function_put)(var!(mapa), var!(value))
      end
    end
  end
end
