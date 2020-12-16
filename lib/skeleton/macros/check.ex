defmodule MapSchema.Macros.Check do
  @moduledoc false

  @doc """
  The Check module compone the macros that let us, build the methods is_valid?:

  """
  def install do
    build_check()
  end

  defp build_check do
    quote do
      @doc """
      It´s will return true, if the map follow the schema.
      """
      def unquote(:is_valid?)(var!(mapa)) when is_map(var!(mapa)) do
        put(%{}, var!(mapa))
        true
      catch
        _ -> false
      end
      def unquote(:is_valid?)(_) do
        MapSchema.Exceptions.throw_error_should_be_a_map()
      end
    end
  end

end
