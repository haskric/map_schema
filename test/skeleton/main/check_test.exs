defmodule MapSchema.CheckTest do
  @moduledoc false
  use ExUnit.Case
  alias MapSchema.Examples.Person

  test "Check if it´s valid -> its valid map" do

    person = %{"name" => "ric" , "age" => 30}

    assert Person.is_valid?(person) == true
    assert Person.get_name(person) == "ric"
    assert Person.get_age(person) == 30
  end

  test "Check if it´s valid-> it isnt valid map " do

    person = %{"name" => "ric" , "age" => "30"}

    assert Person.is_valid?(person) == false
  end

end
