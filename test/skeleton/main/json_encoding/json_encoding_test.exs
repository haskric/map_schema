defmodule MapSchema.JsonEncodingTest do
  @moduledoc false
  use ExUnit.Case
  alias MapSchema.Examples.Person

  test "Using json_decode interal use put/2" do
    json = "{\"age\":29,\"name\":\"ric\"}"
    person = Person.json_decode(json)

    assert Person.get_name(person) == "ric"
    assert Person.get_age(person) == 29

    assert Person.json_encode(person) == "{\"age\":29,\"name\":\"ric\"}"
  end

  test "Using json_decode interal use put/2 with nested maps" do
    json = "{\"age\":29,\"contact\":{\"email\":\"ric@gmail.com\"},\"name\":\"ric\"}"
    person = Person.json_decode(json)

    assert Person.get_name(person) == "ric"
    assert Person.get_age(person) == 29
    assert Person.get_contact_email(person) == "ric@gmail.com"

    assert Person.json_encode(person) == "{\"age\":29,\"contact\":{\"email\":\"ric@gmail.com\"},\"name\":\"ric\"}"
  end

  test "Using put flexible nested" do
    json = "{\"age\":29,\"contact\":{\"email\":\"ric@gmail.com\",\"others\":{\"social\":\"ric\"}},\"name\":\"ric\"}"
    person = Person.json_decode(json)

    assert Person.get_name(person) == "ric"
    assert Person.get_age(person) == 29
    assert Person.get_contact_email(person) == "ric@gmail.com"
    assert Person.get_contact_others(person) == %{"social"=> "ric"}

    result_json = Person.json_encode(person)
    assert result_json == "{\"age\":29,\"contact\":{\"email\":\"ric@gmail.com\",\"others\":{\"social\":\"ric\"}},\"name\":\"ric\"}"
  end

end
