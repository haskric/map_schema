defmodule MapSchema.Examples.TestingExample do
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
    }

end
