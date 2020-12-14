defmodule Item do
  @moduledoc false
  ## Example of recursive type
  use MapSchema,
    type_name: "<item>",
    type_list_name: "<list_items>",
    schema: %{
      "name" => :string,
      "list_items" => "<list_items>"
    },
    custom_types: %{
      "<item>" => MapSchema.DefineTypeTest.Item.Type,
      "<list_items>" => MapSchema.DefineTypeTest.Item.TypeList
    }
end
