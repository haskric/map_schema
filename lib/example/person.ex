defmodule MapSchema.Examples.Person do
  @moduledoc false
  use MapSchema,
    schema: %{
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
