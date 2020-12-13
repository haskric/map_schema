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
        },
        "friends" => :list_people,
        "family" => :list_people

    },
    custom_types: [
      MapSchema.Examples.CustomTypeLang,
      MapSchema.Examples.CustomTypeRecursive.ListPeople
    ]

end
