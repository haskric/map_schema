defmodule MapSchema.Macros.AtomizeMode do
  @moduledoc false
  @doc """
  The base install

  """
  def install(flag_atomize) do
    build_is_atomize(flag_atomize)
  end

  defp build_is_atomize(flag_atomize) do
    quote bind_quoted: [flag_atomize: flag_atomize]  do
      @doc """
      Say if the schema use Atomize mode.
      """
      def unquote(:schema_is_atomize?)() do
        unquote(flag_atomize)
      end
    end
  end

end
