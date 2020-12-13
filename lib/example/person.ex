defmodule MapSchema.Examples.Person do
  @moduledoc """
  Person example
  """
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
    },
    custom_types: [
      MapSchema.DefaultTypes.MSchemaFloat,
      MapSchema.DefaultTypes.MSchemaInteger,
      MapSchema.DefaultTypes.MSchemaString
    ]

end
