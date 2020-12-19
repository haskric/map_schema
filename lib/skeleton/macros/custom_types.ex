defmodule MapSchema.Macros.CustomTypes do
  @moduledoc false
  @doc """
  The custom types install

  """

  def install(custom_types) do
    install_types_functions(custom_types)
  end

  def install_types_functions(custom_types) do
    custom_types = Macro.escape(custom_types)
    quote bind_quoted: [custom_types: custom_types] do
      @doc """
      Map of types
      """
      def unquote(:schema_types)() do
        unquote(Macro.escape(custom_types))
      end

      @doc """
      Get the module of type by name
      """
      def unquote(:schema_get_type_module)(var!(type)) do
        schema_types()
        |> MapSchema.Types.get_custom_type_module(var!(type))
      end
    end
  end

end
