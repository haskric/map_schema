defmodule MapSchema.ReadmeExamplesTest do
  @moduledoc false
  use ExUnit.Case
  alias MapSchema.Examples.Person

  test "Example mutation of age" do
    person = Person.new()
    |> Person.put_age(29)
    |> Person.mut_age(&(&1 + 1))

    assert Person.get_age(person) == 30
  end

  test "Example general put function" do
    person = Person.new()
    person = Person.put(person, %{
      "contact" => %{"email" => "example@mail.com" },
      "country" => "Spain"
    })

    assert Person.get_contact_email(person) == "example@mail.com"
    assert Person.get_country(person) == "Spain"
  end

  test "Example of json encoding" do
    person = Person.new()
    person = Person.put(person, %{
      "contact" => %{"email" => "hi@mail.com" },
      "age" => 45
    })

    json = Person.json_encode(person)
    json_expected = "{\"age\":45,\"contact\":{\"email\":\"hi@mail.com\"}}"
    assert json == json_expected

    person_json = Person.json_decode(json)

    assert Person.get_contact_email(person_json) == "hi@mail.com"
    assert Person.get_age(person_json) == 45
  end

end
