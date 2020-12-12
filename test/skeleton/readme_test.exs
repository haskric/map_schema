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

end
