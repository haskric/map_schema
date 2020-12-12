defmodule MapSchema.BaseTest do
  @moduledoc false
  use ExUnit.Case
  alias MapSchema.Examples.Person

  test "New object" do
    assert Person.new() == %{}
  end

  test "get schema" do
    assert Person.schema() == %{
      "name" => :string,
      "surname" => :string,
      "country" => :string,
      "age" => :integer,
      "contact" => %{
        "email" => :string,
        "phone" => :string,
        "others" => :any
      }
    }
  end

  test "Define module with MapSchema" do
    defmodule TestingMapSchema do
      @moduledoc false
      use MapSchema,
        schema: %{
            "string" => :string,
            "int" => :integer,
            "float" => :float,
            "list" => :list,
            "bool" => :bool,
            "boolean" => :boolean,
            "map" => :map,
            "any" => :any,
            "string_autocast_to_integer" => :string_to_integer,
            "string_autocast_to_float" => :string_to_float,
            "custom_type" => :custom_type,
            "nested" => %{
              "string" => :string,
              "int" => :integer,
              "float" => :float,
              "list" => :list,
              "bool" => :bool,
              "boolean" => :boolean,
              "map" => :map,
              "any" => :any,
              "string_autocast_to_integer" => :string_to_integer,
              "string_autocast_to_float" => :string_to_float,
              "custom_type" => :custom_type
            }
        }
    end

  end

end
