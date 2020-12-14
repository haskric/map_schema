defmodule MapSchema.Macros.PutPartial do
  @moduledoc false
  @doc """
  The PutPartial module compone the macros that let us build the `put/2`
  that put a new values usign a map.

  It´s method check the type of every property following the schema.

  # Example:

      person = Person.new()
        |> Person.put(%{"name" => "ric",  "age"=> 29})

      assert Person.get_name(person) == "ric"
      assert Person.get_age(person) == 29

  """
  alias MapSchema.Methods.PutPartialTypes

  def install do
    install_put_partial()
  end

  defp install_put_partial do
    quote do
      @doc """
      Put a new value in each field of the update map,  in the field of the object.

      But before of update the values always will be check the type.
      If a field dont exist in the schema throw exception. (If you need be less strict you can use `put_ifmatch/1` or `put_ifmatch/2`)
      """
      def unquote(:put)(var!(map_update)) when is_map(var!(map_update)) do
        put(%{}, var!(map_update))
      end

      @doc """
      Put a new value in each field of the update map,  in the field of the object.

      But before of update the values always will be check the type.
      If a field dont exist in the schema throw exception. (If you need be less strict you can use `put_ifmatch/1` or `put_ifmatch/2`)
      """
      def unquote(:put)(var!(mapa), var!(map_update)) when is_map(var!(map_update)) do
        var!(atomize) = schema_is_atomize?()
        var!(custom_types) = schema_types()
        PutPartialTypes.put(__MODULE__, var!(mapa), var!(map_update), var!(custom_types), var!(atomize))
      end

      @doc """
      Put a new value in each field of the update map, in the field of the object only if exist the field in the schema (ifmatch)

      But before of update the values always will be check the type.
      """
      def unquote(:put_ifmatch)(var!(map_update)) when is_map(var!(map_update)) do
        put_ifmatch(%{}, var!(map_update))
      end

      @doc """
      Put a new value in each field of the update map, in the field of the object only if exist the field in the schema (ifmatch)

      But before of update the values always will be check the type.
      """
      def unquote(:put_ifmatch)(var!(mapa), var!(map_update)) when is_map(var!(map_update)) do
        var!(atomize) = schema_is_atomize?()
        var!(custom_types) = schema_types()
        PutPartialTypes.put_ifmatch(__MODULE__, var!(mapa), var!(map_update), var!(custom_types), var!(atomize))
      end

    end
  end

end
