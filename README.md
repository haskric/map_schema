# MapSchema

It´s a Simple, Agile, Map schema in Elixir **with types check** , with **integer and float number autocasting** of string to number, let define **custom types with casting and validation** and include **json encoding** using the popular Jason library.... furthermore it can build the **documentation with doctest for validation your schemas** and share easily with your agile team.

**Next release**
Note: Now, I am working in improve it. You can use it but return here for check updates and documentation. 

## Installation

```elixir
def deps do
  [
    {:map_schema, "~> 0.2.2"}
  ]
end
```

## Usage

The map_schema will include in the module multiple methods
with documentation even with some doctest examples... ;) 
then it´s simple create your schema, add ``ex_doc`` in mix, and use ``mix docs`` and your team will can see all methods that your module will have thanks the "witchcraft" of elixir macros, all ready to use it.

```elixir
defmodule MapSchema.Examples.Person do
  @moduledoc """
  Example of Person Model Map using MapSchema
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
```

### Basics functions
| Method | Description |
| :---: | :---: |
| new         | Constructor         |
| schema      | Return the Schema    |
| is_valid?(map) | Is valid the map? |

### Gets and Puts functions
```elixir
  test "Example get and put usage" do
    person = Person.new() # %{}
      |> Person.put_name("Leo") # %{"name" => "Leo"}
      |> Person.put_surname("Messi") # %{"name" => "Leo", "surname" => "Messi" }
      |> Person.put_country("Argentina") # %{"name" => "Leo", "surname" => "Messi", "country" => "Argentina" }
      |> Person.put_age(33) # %{"name" => "Leo", "surname" => "Messi", "country" => "Argentina", "age" => 33 }
      |> Person.put_lang("ES") # %{"name" => "Leo", "surname" => "Messi", "country" => "Argentina", "age" => 33 , "lang" => "es"} 
      
      # the lang field it´s custom type :language_iso639 make automatic # the downcase in strings before of validate. 
      # Review the example MapSchema.Examples.CustomTypeLang

    assert Person.get_name(person) == "Leo"
    assert Person.get_surname(person) == "Messi"
    assert Person.get_country(person) == "Argentina"
    assert Person.get_age(person) == 33
    assert Person.get_lang(person) == "es"
  end
```

| Gets | Puts |
| :--- | :--- |
| get_name(map)      | put_name(map,value)  |   
| get_surname(map)      | put_surname(map,value)  |
| get_country(map)      | put_country(map,value)  |
| get_age(map)      | put_age(map,value)  |
| get_contact_email(map)      | put_contact_email(map,value)  |
| get_contact_phone(map)      | put_contact_phone(map,value)  |
| get_contact_others(map)      | put_contact_others(map,value)  |

### General Put and Put_ifmatch

You can update many fields using a general put, every field will be cast and type check before of update. But if you try put a field that dont exist in the schema the method put will return a exception because you tried break the schema. Well there are a other option, you can use `put_ifmatch` that if a field dont exist in the schema it will omited.

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

```elixir
  test "Using put with exception and put_ifmatch without exception" do
    try do
      Person.new()
      |> Person.put(%{"name" => "ric", "not_exist_field"=> "something"})

      assert false
    catch
      e ->
        assert e == Exceptions.not_exist_field_in_schema("not_exist_field")
        person = Person.new()
          |> Person.put_ifmatch(%{"name" => "ric", "not_exist_field"=> "something"})

        assert Person.get_name(person) == "ric"
    end
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


### Json Encoding

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

| Method | Description |
| :--- | :---: |
| json_encode(map) | Map to Json |
| json_encode(json) | Json to Map (Check typing, and cast) |
| json_encode(mapa, json) | Json to Existing Map (Checking typing, and cast) |


### Atomize Schema (Dot Sintax) ( Only in Versions > 0.2.2 )

```elixir
defmodule MapSchema.Examples.Employee do
  use MapSchema,
    atomize: true,
    schema: %{
        :name => :string,
        :surname => :string,
        :contact => %{
          :email => :string,
        }
    },
    custom_types: []
end
```

In the next release you will can active atomize mode in your schemas, this can be problematic with json_encoding then we need say the schema that you want use it. It´s important this because let us use a doc sintax to access easy the information.


```elixir
  test "New employee get with dot sintax" do
    emp = Employee.new()
      |> Employee.put_name("Ric")
      |> Employee.put_surname("H")
      |> Employee.put_contact_email("nested@email.com")

    assert emp.name == "Ric"
    assert Employee.get_name(emp) == "Ric"

    assert emp.surname == "H"
    assert Employee.get_surname(emp) == "H"

    assert emp.contact.email == "nested@email.com"
    assert Employee.get_contact_email(emp) == "nested@email.com"
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

### Recursive Custom Type example of use

```elixir
  test "Example using recursive list of people" do
    person_neymar = Person.new()
      |> Person.put_name("Neymar")

    person_messi = Person.new()
      |> Person.put_name("Leo")
      |> Person.put_surname("Messi")
      |> Person.put_friends([
        %{"name"=>"Suarez"},
        person_neymar
      ])
      |> Person.put_family([
        %{"name"=>"Antonella"}
      ])

    assert Person.get_name(person_messi) == "Leo"
    assert Person.get_surname(person_messi) == "Messi"
    assert Person.get_friends(person_messi) == [
      %{"name"=>"Suarez"},
      person_neymar
    ]
    assert Person.get_family(person_messi) == [
      %{"name"=>"Antonella"}
    ]
  end
```
### Custom Type example

```elixir
defmodule MapSchema.Examples.CustomTypeLang do
  @moduledoc """
  MapSchema.Examples.CustomTypeLang

    Imagine here a query to Database or any place where you have
    the list https://www.iso.org/iso-639-language-codes.html
    https://es.wikipedia.org/wiki/ISO_639-1
    only if the value exist it will be valid in other case
    the schema wont be valid. It´s simple. ;)

  """
  @behaviour MapSchema.CustomType

  @spec name :: atom
  def name, do: :language_iso639
  def nested?, do: false

  @doc """
  We are interesting in that every string will be lowcase.
  then it´s simple we add in the cast a function that make downcase.

  ## Examples

    iex> alias MapSchema.Examples.CustomTypeLang
    iex> CustomTypeLang.cast("ES")
    ...> |> CustomTypeLang.is_valid?()
    true

    iex> alias MapSchema.Examples.CustomTypeLang
    iex> CustomTypeLang.cast(nil)
    :error

  """
  @spec cast(any) :: any | :error
  def cast(value) when is_bitstring(value) do
    value
    |> String.downcase()
  end
  def cast(_), do: :error

  @doc """
   In this example our database it´s a simple list with
   ["zh", "en", "es"]

  ## Examples

      iex> alias MapSchema.Examples.CustomTypeLang
      iex> CustomTypeLang.is_valid?("zh")
      true
      iex> CustomTypeLang.is_valid?("en")
      true
      iex> CustomTypeLang.is_valid?("es")
      true

      iex> alias MapSchema.Examples.CustomTypeLang
      iex> CustomTypeLang.is_valid?("ES")
      false

      iex> alias MapSchema.Examples.CustomTypeLang
      iex> CustomTypeLang.is_valid?("Español")
      false

  """
  @spec is_valid?(any) :: boolean
  def is_valid?(value) do
    ## Imagine here a query to Database or any place where you have
    ## the list https://www.iso.org/iso-639-language-codes.html
    ## https://es.wikipedia.org/wiki/ISO_639-1
    ## only if the value exist it will be valid.
    value in ["zh", "en", "es"]
  end


  @doc """
  Stop... the magic continue. After define our cast and validation functions
  we can define a generador of doctest... Yes ¡¡ You are reading well.. TEST FREE¡¡

  If you define this function well... you can have a fast test of your new datatype ;)

  This method return a list of tuples [{value_test, expected_value},{.. , ..}...]
  map schema selected a random tuple for build the test ;) Please be careful, and
  test that every tuple it´s correct. Thanks.

  It´s important be careful because the values should be in string format for can be writed
  in the doctest please review that `mix docs` run without problems.


  """
  @spec doctest_values :: [{any, any}]
  def doctest_values do
    ["zh", "en", "es"]
    |> Enum.map(fn(text) -> {"\"#{text}\"", "\"#{text}\""} end)
  end

end
```



### Features

- Simple definition of data schema
  
  A simple map %{} and ;)
- Implicit types check and casting

  Forgot the type checks and casting
- Compatible with Json.

  Perfect, for APIs, webapps... so on.
- Independent data of module

  A map would can be compatible with multiples schemas always that it follow each schema types.
- Custom data types 

  This custom data types let you define the rules of schema.

... and more now working ...