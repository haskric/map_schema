defmodule MapSchema.DefinitionMapSchemaTest do
  @moduledoc false
  use ExUnit.Case
  alias MapSchema.Exceptions

  test "Define with invalid schema" do
    try do
      defmodule InvalidSchema do
        @moduledoc false
        use MapSchema,
          schema: nil
      end

      assert false
    catch
      e ->
        assert e == Exceptions.config_error_schema_should_be_map()
    end
  end

  test "Define custom_types invalid" do
    try do
      defmodule CustomTypesInvalid do
        @moduledoc false
        use MapSchema,
          custom_types: :something_wrong,
          schema: %{
            "name" => :string
          }
      end

      assert false
    catch
      e ->
        assert e == Exceptions.config_error_custom_types_should_be_list_or_map()
    end
  end

  test "Define custom_types empty list is valid" do
      defmodule CustomTypesEmpty do
        @moduledoc false
        use MapSchema,
          custom_types: [],
          schema: %{
            "name" => :string
          }
      end

      assert true
  end

  test "Define fields in string or atom not boths should be ok" do
    try do
       defmodule OnlyStringOrAtom do
          @moduledoc false
          use MapSchema,
            schema: %{
              "string"  => :any,
              :atom => :any
            }
        end

        assert false
    catch
      e ->
        assert e == Exceptions.config_schema_error_the_fields_should_be_string()
    end
  end

  test "Define fields in string" do
    defmodule OnlyString do
      @moduledoc false
      use MapSchema,
        schema: %{
          "string"  => :any,
          "string2" => :any
        }
    end

    assert true
  end

  test "Define fields in string with active atomize" do
    try do
      defmodule StringWithAtomize do
        @moduledoc false
        use MapSchema,
          atomize: true,
          schema: %{
            "field1"  => :any,
            "field2" => :any
          }
      end

      assert false

    catch
      e ->
        assert e == Exceptions.config_schema_error_the_fields_should_be_atom()
    end
  end

  test "Define fields in atom without active atomize" do
    try do
      defmodule OnlyAtomsWithoutAtomize do
        @moduledoc false
        use MapSchema,
          atomize: false,
          schema: %{
            :atom1  => :any,
            :atom2 => :any
          }
      end

      assert false

    catch
      e ->
        assert e == Exceptions.config_schema_error_the_fields_should_be_string()
    end
  end

  test "Define fields in atom" do
    defmodule OnlyAtoms do
      @moduledoc false
      use MapSchema,
        atomize: true,
        schema: %{
          :atom1  => :any,
          :atom2 => :any
        }
    end

    assert true
  end

end
