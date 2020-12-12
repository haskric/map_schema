defmodule MapSchema.PutPartialTest do
  @moduledoc false
  use ExUnit.Case
  alias MapSchema.Examples.Person

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

end
