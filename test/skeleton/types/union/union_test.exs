defmodule MapSchema.Types.UnionTest do
  @moduledoc false
  use ExUnit.Case
  alias MapSchema.Exceptions

  defmodule StringOrAtomOrIntegerType do
    @moduledoc false
    use MapSchema.Types.TypeUnion,
      name: "<string|atom|integer>",
      types: [
        :string, :atom, :integer
      ]

  end

  defmodule SchemaWithUnionType do
    @moduledoc false

    use MapSchema,
      atomize: true,
      schema: %{
        :field => "<string|atom|integer>"
      },
      custom_types: %{
        "<string|atom|integer>" => MapSchema.Types.UnionTest.StringOrAtomOrIntegerType
      }
  end

  alias MapSchema.Types.UnionTest.SchemaWithUnionType

  test "valid values union" do
    obj = SchemaWithUnionType.new()
      |> SchemaWithUnionType.put_field(1)

    assert obj.field == 1

    obj = SchemaWithUnionType.new()
      |> SchemaWithUnionType.put_field(:example_of_atom)

    assert obj.field == :example_of_atom

    obj = SchemaWithUnionType.new()
      |> SchemaWithUnionType.put_field("string_example")

    assert obj.field == "string_example"
  end

  test "invalid values union" do
    try do
      _obj = SchemaWithUnionType.new()
        |> SchemaWithUnionType.put_field([1, 2, 3])

    catch
      e ->
        assert e == Exceptions.cast_error("field", "<string|atom|integer>")
    end
  end

  test "Cannot use a type dont define" do

    try do
      defmodule UnionWithTypeDontDefinid do
        @moduledoc false
        use MapSchema.Types.TypeUnion,
          name: "<string|atom>",
          types: [
            :string, :atom, :hola_mundo
          ]

      end
    catch
      e ->
        assert e == Exceptions.config_union_type_definition_error()
    end
  end

  test "Cannot use a module that isnt a module map_schema defined" do

    try do
      defmodule UnionWithTypeDontDefinid do
        @moduledoc false
        use MapSchema.Types.TypeUnion,
          name: "<string|atom>",
          types: [
            :string, :atom, MapSchema.Types.UnionTest
          ]

      end
    catch
      e ->
        assert e == Exceptions.config_union_type_definition_error()
    end
  end

end
