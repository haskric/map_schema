# MapSchema

It´s a Simple, Agile, Map schema in Elixir **with types check** , with **autocasting of integer and floats** of string to number and include **json encoding** using Jason library. 

## Installation

```elixir
def deps do
  [
    {:map_schema, "~> 0.1.0"}
  ]
end
```

## Usage 
```elixir
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
```
With the magic of macros you will have the following methods 

### Basics functions
| Method | Description |
| :---: | :---: |
| new         | Constructor         |
| schema      | Schema              |
| is_valid?(map) | Is valid the map? |

### Gets and Puts functions

| Gets | Puts |
| :--- | :--- |
| get_name(map)      | put_name(map,value)  |   
| get_surname(map)      | put_surname(map,value)  |
| get_country(map)      | put_country(map,value)  |
| get_age(map)      | put_age(map,value)  |
| get_contact_email(map)      | put_contact_email(map,value)  |
| get_contact_phone(map)      | put_contact_phone(map,value)  |
| get_contact_others(map)      | put_contact_others(map,value)  |

### General Put

```elixir
  test "Example general put function" do
    person = Person.new() # %{}
    person = Person.put(person, %{
      "contact" => %{"email" => "example@mail.com" },
      "country" => "Spain"
    }) # %{"country" => "Spain","contact" => %{"email" => "example@mail.com"}}

    assert Person.get_contact_email(person) == "example@mail.com"
    assert Person.get_country(person) == "Spain"
  end
```


### Mutation functions

```elixir
  test "Example mutation of age" do
    person = Person.new() # %{}
    |> Person.put_age(29) # %{"age" => 29}
    |> Person.mut_age(&(&1 + 1)) # %{"age" => 30}

    assert Person.get_age(person) == 30
  end
```

| Method | Description |
| :--- | :---: |
| mut_name(map,fn_mut) | Change the value of name using fn_mut |
| mut_surname(map,fn_mut) | Change the value of surname using fn_mut |
| mut_country(map,fn_mut) | Change the value of country using fn_mut |
| mut_age(map,fn_mut) | Change the value of age using fn_mut |
| mut_contact_email(map,fn_mut) | Change the value using fn_mut |
| mut_contact_phone(map,fn_mut) | Change the value using fn_mut |
| mut_contact_others(map,fn_mut) | Change the value using fn_mut |


### JSON ENCONDING 


| Method | Description |
| :--- | :---: |
| json_encode(map) | Map to Json |
| json_encode(json) | Json to Map (Check typing, and cast) |
| json_encode(mapa, json) | Json to Existing Map (Checking typing, and cast) |

```elixir
  test "Example of json encoding" do
    person = Person.new()
    person = Person.put(person, %{
      "contact" => %{"email" => "hi@mail.com" },
      "age" => 45
    })

    json = Person.json_encode(person)
    json_expected ="{\"age\":45,\"contact\":{\"email\":\"hi@mail.com\"}}"
    assert json == json_expected

    person_json = Person.json_decode(json)

    assert Person.get_contact_email(person_json) == "hi@mail.com"
    assert Person.get_age(person_json) == 45
  end
```

### Table of Types

Note:
**:string_to_integer** and **:string_to_float** make **implicit the cast of string to number** then automatic and simple you will have your information in the right format and type following the schema define. ;)


| Type | Use Guard |
| :---: | :---: |
| :integer         | :is_integer         |
| :float      | :is_float             |
| :string_to_integer         | :is_integer         |
| :string_to_float      | :is_float             |
| :string | :is_bitstring |
| :bool | :is_boolean |
| :boolean | :is_boolean |
| :map | :is_map |
| :list | :is_list |
| :any | NONE |
| in othercase | NONE |

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/map_schema](https://hexdocs.pm/map_schema).

