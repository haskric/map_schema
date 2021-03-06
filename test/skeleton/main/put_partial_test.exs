defmodule MapSchema.PutPartialTest do
  @moduledoc false
  use ExUnit.Case
  alias MapSchema.Examples.Person
  alias MapSchema.Exceptions

  test "Using put" do
    person = Person.new()
      |> Person.put(%{"name" => "ric", "age"=> 29})

    assert Person.get_name(person) == "ric"
    assert Person.get_age(person) == 29
  end

  test "Using put nested" do
    person = Person.new()
      |> Person.put(%{"name" => "ric", "age"=> 29 , "contact" => %{"email" => "ric@gmail.com"}})

    assert Person.get_name(person) == "ric"
    assert Person.get_age(person) == 29
    assert Person.get_contact_email(person) == "ric@gmail.com"
  end

  test "Using put flexible nested" do
    person = Person.new()
      |> Person.put(%{"name" => "ric", "age"=> 29 , "contact" => %{"email" => "ric@gmail.com", "others" => %{"social"=> "ric"}}})

    assert Person.get_name(person) == "ric"
    assert Person.get_age(person) == 29
    assert Person.get_contact_email(person) == "ric@gmail.com"
    assert Person.get_contact_others(person) == %{"social"=> "ric"}
  end

  test "Is posible add anything in flexible nested field" do
    defmodule TestingNested do
      @moduledoc false
      use MapSchema,
        schema: %{
          "flex_nested" => :any,
          "flex_second" => :any
        }
    end

    item = TestingNested.new()
      |> TestingNested.put_flex_nested(%{hello: "world"})
      |> TestingNested.put(%{"flex_second" => %{hola: "mundo"}})

    assert TestingNested.get_flex_nested(item) == %{hello: "world"}
    assert TestingNested.get_flex_second(item) == %{hola: "mundo"}
end

  test "Using put with exception and put_ifmatch without exception" do
    try do
      Person.new()
      |> Person.put(%{"name" => "ric", "not_exist_field"=> "something"})

      assert false
    catch
      e ->
        assert e == Exceptions.not_exist_field_in_schema("not_exist_field")
        person = Person.new()
          |> Person.put_ifmatch(%{"name" => "ric", "not_exist_field"=> "something"})

        assert Person.get_name(person) == "ric"
    end
  end
end
