defmodule MapSchema.Macros.DefineType do
  @moduledoc false
  @doc """
  Install in the schema the callbacks of custom_types
  for transforma the schema in a custom type.

  """
  def install(type_name, type_list_name) do
    deftype = install_custom_type(type_name)
    deftype_list = install_custom_type_list(type_list_name)

    [deftype, deftype_list]
  end

  def install_custom_type(:not_deftype), do: []
  def install_custom_type(type_name) do
    quote bind_quoted: [type_name: type_name] do
      module = __MODULE__
      defmodule Type do
        @moduledoc """
        CustomType #{module}
        """
        @behaviour MapSchema.CustomType

        def name, do: unquote(type_name)

        def nested?, do: true

        def cast(var!(value)), do: var!(value)

        def is_valid?(var!(value)) do
          apply(unquote(module), :is_valid?, [var!(value)])
        end

        def doctest_values, do: []

      end
    end
  end

  def install_custom_type_list(:not_deftype), do: []
  def install_custom_type_list(type_list_name) do
    quote bind_quoted: [type_list_name: type_list_name] do
      module = __MODULE__
      defmodule TypeList do
        @moduledoc """
        TypeList #{module}
        """
        @behaviour MapSchema.CustomType

        def name, do: unquote(type_list_name)

        def nested?, do: true

        def cast(var!(list_items)) do
          var!(list_items)
          |> Enum.map(fn(var!(item)) ->
            apply(unquote(module), :put, [var!(item)])
          end)
        catch
          _e ->
            :error
        end

        def is_valid?(var!(_value)), do: true

        def doctest_values, do: []

      end
    end
  end

end
