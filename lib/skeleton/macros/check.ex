defmodule MapSchema.Check do
  @moduledoc """
  The Check module compone the macros that let us, build the methods is_valid?:

  `is_valid?(map)`

  """
  def install do
    build_check()
  end

  defp build_check do
    quote do
      @doc """
      It´s will return true, if the map follow the schema.
      """
      def unquote(:is_valid?)(var!(mapa)) do
        put(%{}, var!(mapa))
        true
      catch
        _ -> false
      end
    end
  end

end
