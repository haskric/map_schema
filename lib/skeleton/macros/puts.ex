defmodule MapSchema.Puts do
  @moduledoc """
  The Puts module compone the macros that let us, build the methods put:

  - `put(map,field,value)`

  """
  alias MapSchema.Methods.Puts
  alias MapSchema.Utils

  def install(lista_fields, type) do
    build_puts(lista_fields, type)
  end

  defp build_puts(lista_fields, type) do
    guard = Utils.get_guard_by_type(type)
    case {type, guard} do
      {_, nil} -> build_puts_without_guard(lista_fields)
      {:string_to_float, _} -> build_puts_casting(lista_fields, :string_to_float)
      {:string_to_integer, _} -> build_puts_casting(lista_fields, :string_to_integer)
      {_, _} ->
        build_puts_guard(lista_fields, type)
    end
  end

  defp build_puts_without_guard(lista_fields) do
    field = Utils.get_field_name(lista_fields)

    quote bind_quoted: [field: field,  lista_fields: lista_fields] do
      name_function = String.to_atom("put_" <> field)
      @doc """
      Put a new value in #{field} field.
      """
      def unquote(name_function)(var!(mapa), var!(value)) do
        Puts.generic_put(var!(mapa), unquote(lista_fields), var!(value))
      end
    end
  end

  defp build_puts_casting(lista_fields, type) do
    field = Utils.get_field_name(lista_fields)
    guard = Utils.get_guard_by_type(type)

    {testing_value, testing_result} = Utils.build_test_values(type)

    quote bind_quoted: [field: field,  testing_value: testing_value ,  testing_result: testing_result ,
    lista_fields: lista_fields,  type: type ,  guard: guard] do
      name_function = String.to_atom("put_" <> field)
      cast_function_check = "#{guard}!" |> String.replace("is_", "to_") |> String.to_atom()
      @doc """
      Put a new value in #{field} field,  but it´s value is string try cast using `#{cast_function_check}`

      ## Example:

            iex>obj = #{__MODULE__}.new()
            ...> |> #{__MODULE__}.put_#{field}(#{testing_value})
            iex> #{__MODULE__}.get_#{field}(obj)
            #{testing_result}


      """
      def unquote(name_function)(var!(mapa), var!(value)) when is_bitstring(var!(value)) do
        case apply(Elixir.MapSchema.ExuString, unquote(cast_function_check), [var!(value)]) do
          :error ->
            throw("Error cast #{unquote(field)}")
          var!(num) ->
            unquote(name_function)(var!(mapa), var!(num))
        end
      end
      def unquote(name_function)(var!(mapa), var!(value)) when unquote(guard)(var!(value)) do
        Puts.generic_put(var!(mapa), unquote(lista_fields), var!(value))
      end
      def unquote(name_function)(var!(_mapa), var!(_value)) do
        throw("Error type #{unquote(name_function)} we are using #{unquote(guard)} guard to type check.")
      end
    end
  end

  defp build_puts_guard(lista_fields, type) do

    field = Utils.get_field_name(lista_fields)
    guard = Utils.get_guard_by_type(type)

    {testing_value, _} = Utils.build_test_values(type)

    #IO.puts " #{field} check #{testing_value}"
    quote bind_quoted: [field: field,  testing_value: testing_value ,
    lista_fields: lista_fields,  type: type ,  guard: guard] do
      name_function = String.to_atom("put_" <> field)

      @doc """
      Put a new value in #{field} field.
      Before of update the valor will be check it.

      Remember that #{field} is #{type} type.

      ## Example:

            iex>obj = #{__MODULE__}.new()
            ...> |> #{__MODULE__}.put_#{field}(#{testing_value})
            iex> #{__MODULE__}.get_#{field}(obj)
            #{testing_value}

      """
      def unquote(name_function)(var!(mapa), var!(value)) when unquote(guard)(var!(value)) do
        Puts.generic_put(var!(mapa), unquote(lista_fields), var!(value))
      end
      def unquote(name_function)(var!(_mapa), var!(_value)) do
        throw("Error type #{unquote(name_function)} we are using #{unquote(guard)} guard to type check.")
      end
    end
  end

end
