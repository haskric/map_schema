defmodule MapSchema.DefineTypeTest do
  @moduledoc false
  use ExUnit.Case

  alias MapSchema.Exceptions


  test "Recursive definition MapSchema" do

    defmodule Item do
      @moduledoc false
      use MapSchema,
        type_list_name: "<list_items>",
        schema: %{
          "name" => :string,
          "list_items" => "<list_items>"
        },
        custom_types: [
          MapSchema.DefineTypeTest.Item.TypeList
        ]
    end

    IO.inspect Item.schema_types()

  end

  test "Autodefinition of type that let us use in others MapSchema" do

    defmodule Phone do
      @moduledoc false
      use MapSchema,
        type_name: "<phone>",
        type_list_name: "<list_phones>",
        schema: %{
          "ext" => :string,
          "phone" => :string
        }
    end

    defmodule Restaurant do
      @moduledoc false
      use MapSchema,
        schema: %{
          "name" => :string,
          "phone" => "<phone>"
        },
        custom_types: [
          MapSchema.DefineTypeTest.Phone.Type
        ]
    end

    phone = Phone.new()
      |> Phone.put_ext("+35")
      |> Phone.put_phone("298374..")

    bar = Restaurant.new()
      |> Restaurant.put_name("Boio")
      |> Restaurant.put_phone(phone)

    assert Restaurant.get_name(bar) == "Boio"
    assert Restaurant.get_phone(bar) == %{"ext"=>"+35", "phone"=>"298374.."}

    try do
      bar
      |> Restaurant.put_phone(%{"ext"=>:bar_type, "phone"=> 10_293})
    catch
      e ->
        ## Expected something similar to:

        ## "Type error: the field \"phone\" it´s \"<phone>\".
        ##Review the type it please.
        assert e == Exceptions.type_error("phone", "<phone>")
    end

  end
end
