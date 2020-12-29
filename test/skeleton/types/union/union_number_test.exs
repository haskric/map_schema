defmodule MapSchema.Types.NumberType.Test do
  @moduledoc false
  use ExUnit.Case
  alias MapSchema.Exceptions

  defmodule SchemaWithNumber do
    @moduledoc false

    use MapSchema,
      atomize: true,
      schema: %{
        :field => :number
      }

  end

  test "valid number" do
    obj = SchemaWithNumber.new()
      |> SchemaWithNumber.put_field(1)

    assert obj.field == 1

    obj = SchemaWithNumber.new()
      |> SchemaWithNumber.put_field(10.2)

    assert obj.field == 10.2

    obj = SchemaWithNumber.new()
      |> SchemaWithNumber.put_field("1")

    assert obj.field == 1

    obj = SchemaWithNumber.new()
    |> SchemaWithNumber.put_field("10.2")

    assert obj.field == 10.2
  end

  test "invalid values union" do
    try do
      _obj = SchemaWithNumber.new()
        |> SchemaWithNumber.put_field(:atom)

    catch
      e ->
        assert e == Exceptions.cast_error("field", :number)
    end
  end

end
