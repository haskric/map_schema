defmodule MapSchema.Types.TypeUnion do
  @moduledoc """
  Macro for creation Union types.
  """

  alias MapSchema.Exceptions
  alias MapSchema.Types.Default
  alias MapSchema.Types.TypeUnion.Methods

  defmacro __using__(opts) do
    name = Keyword.get(opts, :name)
    list_types = Keyword.get(opts, :types)
      |> transform_list_types()

    quote bind_quoted: [name: name, list_types: list_types] do

      @behaviour MapSchema.CustomType

      @spec name :: atom | String.t()
      def name, do: unquote(name)

      # I dont know
      def nested?, do: true

      @spec cast(value :: any) :: any | :map_schema_type_error
      def cast(value) do
        Methods.cast(value, unquote(list_types))
      end

      @spec is_valid?(any) :: boolean
      def is_valid?(value) do
        Methods.is_valid?(value, unquote(list_types))
      end

      @spec doctest_values :: [{any, any}]
      def doctest_values do
        Methods.doctest_values(unquote(list_types))
      end

    end
  end

  defp transform_list_types(list_types) do
    {list_types, []} =  Code.eval_quoted(list_types)

    list_types
    |> Enum.map(fn(type_module) ->
      cond do
        is_valid_module?(type_module) -> type_module
        is_atom(type_module) ->
          Default.get_default_type_module(type_module)
        true ->
          throw :error
      end
    end)
  catch
    _e ->
      Exceptions.throw_config_union_type_definition_error()
  end

  defp is_valid_module?(module) do
    is_module?(module) and is_map_schema_module?(module)
  end

  defp is_module?(module) do
    function_exported?(module, :__info__, 1)
  end
  defp is_map_schema_module?(module) do
    function_exported?(module, :cast, 1)
    and
    function_exported?(module, :is_valid?, 1)
    and
    function_exported?(module, :doctest_values, 0)
  end

end
