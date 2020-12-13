defmodule MapSchema.Examples.Person do
  @moduledoc """
  Person example
  """
  use MapSchema,
    schema: %{
        "name" => :string,
        "surname" => :string,
        "country" => :string,
        "lang" => :language_iso639,
        "age" => :integer,
        "contact" => %{
          "email" => :string,
          "phone" => :string,
          "others" => :any
        }
    },
    custom_types: [
      MapSchema.Examples.CustomTypeLang
    ]

end
