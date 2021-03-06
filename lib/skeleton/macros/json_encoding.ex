defmodule MapSchema.Macros.JsonEncoding do
  @moduledoc false
  @doc """
  The JsonEncoding module compone the macros that let us,  build the methods:

  - json_encode(map)
  Take a map and cast to json string format.
  - json_decode(json)
  Take a json string format and build a map,  following the rules of schema.

  Note:It´s check the data types.
  - json_decode(mapa, json)
  Take a json string format and build a map,  change the values of the actual map following the rules of schema.

  Note:It´s check the data types.


  """
  def install do
    encode_methods = install_json_encode()
    decore_1_using_mapschema = install_decode_to_mapschema()
    decode_2_mutable = install_decode_mutable()

    [encode_methods, decore_1_using_mapschema, decode_2_mutable]
  end

  defp install_json_encode do
    quote do
      @doc """
      Let encode object to Json.

      Note: This method use Jason library.
      """
      def unquote(:json_encode)(var!(mapa)) when is_map(var!(mapa)) do
        Jason.encode!(var!(mapa))
      end
      def unquote(:json_encode)(_) do
        MapSchema.Exceptions.throw_error_should_be_a_map()
      end
    end
  end

  defp install_decode_to_mapschema do
    quote do
      @doc """
      Let decode json to Object. Checking every type following the schema.

      Note: This method use Jason library.
      """
      def unquote(:json_decode)(var!(json)) do
        put(%{}, Jason.decode!(var!(json)))
      end

    end
  end

  defp install_decode_mutable do
    quote do
      @doc """
      Let decode json and mut a existing object . Checking every type following the schema.
      Intenal it´s using the method `put/2`.

      Note: This method use Jason library.

      ## Parameters

      - mapa: Object
      - json: Json object

      """
      @spec json_decode(
        any(),
        binary()
        | maybe_improper_list(
            binary() | maybe_improper_list(any(), binary() | []) | byte(),
            binary() | []
          )
      ) :: any()
      def unquote(:json_decode)(var!(mapa), var!(json)) when is_map(var!(mapa)) do
        put(var!(mapa), Jason.decode!(var!(json)))
      end
      def unquote(:json_decode)(_, _) do
        MapSchema.Exceptions.throw_error_should_be_a_map()
      end
    end
  end

end
