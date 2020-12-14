defmodule MapSchema.DefinitionCustomTypeTest do
  @moduledoc false
  use ExUnit.Case

  alias MapSchema.Exceptions

  test "Type dont undefined" do
    try do
      defmodule TypeNotUndefined do
        @moduledoc false
        use MapSchema,
          schema: %{
            "name" => :not_undefined
          }
      end

      assert false
    catch
      e ->
        assert e == Exceptions.error_type_dont_undefined("not_undefined")
    end
  end

end
