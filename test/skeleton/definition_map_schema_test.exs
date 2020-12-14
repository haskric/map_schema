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

end
