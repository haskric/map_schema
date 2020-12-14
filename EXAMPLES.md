# Examples 
 
## Schema

```elixir
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
```

## Usage Schema get/puts

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

## Put and Put_ifmatch

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


## Atomize

```elixir
defmodule MapSchema.Examples.Employee do
  @moduledoc """
  Employee example
  """
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

## Usage Dot Sintax

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


## Custom Type

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

  ## Examples

      iex> alias MapSchema.Examples.CustomTypeLang
      iex> CustomTypeLang.doctest_values()
      [{"\\"zh\\"", "\\"zh\\""}, {"\\"en\\"", "\\"en\\""}, {"\\"es\\"", "\\"es\\""}]

  """
  @spec doctest_values :: [{any, any}]
  def doctest_values do
    ["zh", "en", "es"]
    |> Enum.map(fn(text) -> {"\"#{text}\"", "\"#{text}\""} end)
  end

end
```

