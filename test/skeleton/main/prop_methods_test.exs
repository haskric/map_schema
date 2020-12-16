defmodule MapSchema.ProdMethodsTest do
  @moduledoc false
  use ExUnit.Case
  alias MapSchema.Examples.Person

  test "Using put & get of person MapSchema" do
    person = Person.new()
      |> Person.put_name("ric")
      |> Person.put_age(29)

    assert Person.get_name(person) == "ric"
    assert Person.get_age(person) == 29
  end

  test "Using mutation of person, adding 1 year" do
    person = Person.new()
      |> Person.put_age(29)
      |> Person.mut_age(&(&1 + 1))

    assert Person.get_age(person) == 30
  end

end
