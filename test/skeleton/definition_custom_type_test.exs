defmodule MapSchema.DefinitionCustomTypeTest do
  @moduledoc false
  use ExUnit.Case
  alias MapSchema.Exceptions

  test "Now, you can define custom type with doctest empty" do
    try do
      defmodule CanntDoctestEmpty do
        @moduledoc false

        @behaviour MapSchema.CustomType

        @spec name :: atom
        def name, do: :any
        def nested?, do: true

        @spec cast(any) :: any
        def cast(value) do
          value
        end

        @spec is_valid?(any) :: boolean
        def is_valid?(_value) do
          true
        end

        @spec doctest_values :: [{any, any}]
        def doctest_values do
          []
        end
      end

      assert true
    catch
      e ->
        ## Dont arrive because the exception is catched before...
        assert e != Exceptions.error_set_of_doctest_cannot_be_empty()
    end
  end

end
