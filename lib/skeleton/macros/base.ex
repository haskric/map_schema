defmodule MapSchema.Base do
  @moduledoc """
  The base install

  - simple constructor `new/0`
  - schema getter `schema/0`

  """
  def install(schema) do
    schema_fn = install_schema(schema)
    new_fn = install_new()

    [schema_fn, new_fn]
  end

  defp install_new do
    quote do
      @doc """
      This method only create a new simple map %{}. Yes.

      Because the idea it´s the data structure will be independent of MapSchema
      but the module will have the schema that the maps should be follow.

      ## Example:

            iex>#{__MODULE__}.new()
            %{}

      """
      def unquote(:new)() do
        %{}
      end
    end
  end

  defp install_schema(schema) do
    quote bind_quoted: [schema: schema] do
      @doc """
      The Schema is:
      #{Macro.to_string(schema)}
      """
      def unquote(:schema)() do
        unquote(Macro.escape(schema))
      end
    end
  end

end
