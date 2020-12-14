defmodule MapSchema.Macros.Check do
  @moduledoc false
  @doc """
  The Check module compone the macros that let us, build the methods is_valid?:

  `is_map_valid?(map)`

  Sorry I need rename this method because I would like make compatible a mapschema
  with customtype.
  """
  def install do
    build_check()
  end

  defp build_check do
    quote do
      @doc """
      It´s will return true, if the map follow the schema.
      """
      def unquote(:is_map_valid?)(var!(mapa)) do
        put(%{}, var!(mapa))
        true
      catch
        _ -> false
      end
    end
  end

end
