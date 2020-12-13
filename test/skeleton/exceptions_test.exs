defmodule MapSchema.ExceptionsTest do
  @moduledoc false
  use ExUnit.Case

  alias MapSchema.Examples.Person
  alias MapSchema.Examples.TestingExample
  alias MapSchema.Exceptions

  test "Exception type_error, name is string" do
    try do
      Person.new()
      |> Person.put(%{"name" => 102})

      assert false
    catch
      e ->
        assert e == Exceptions.type_error("name", :string)
    end
  end

  test "Exception cast is String" do
    try do
      TestingExample.new()
      |> TestingExample.put(%{"string_autocast_to_integer" => "it isnt a integer"})

      assert false
    catch
      e ->
        assert e == Exceptions.cast_error("string_autocast_to_integer", :string_to_integer)
    end
  end

  test "not_exist_field_in_schema" do
    try do
      Person.new()
      |> Person.put(%{"not_exist_field"=> "something"})

      assert false
    catch
      e ->
        assert e == Exceptions.not_exist_field_in_schema("not_exist_field")
    end
  end

end
