# Types of MapSchema

## Default Types Supported

* Boolean `:bool` or `:boolean`
* Atom `:atom`
* Numeric types `:float`, `:integer`, `:string_to_float`, `:string_to_float`, and `:number` that it´s the union of others numberic types.
* String `:string`
* Map `:map`
* Anything `:any`
* Keyword `:keyword`
* List `:list`


## Define Custom Type

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
    :map_schema_type_error 

  """
  @spec cast(value :: any) :: any | :map_schema_type_error 
  def cast(value) when is_bitstring(value) do
    value
    |> String.downcase()
  end
  def cast(_), do: :map_schema_type_error

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


### Example of Union type

```elixir
 defmodule StringOrAtomOrIntegerType do
    @moduledoc false
    use MapSchema.Types.TypeUnion,
      name: "<string|atom|integer>",
      types: [
        :string, :atom, :integer
      ]

  end

  defmodule SchemaWithUnionType do
    @moduledoc false

    use MapSchema,
      atomize: true,
      schema: %{
        :field => "<string|atom|integer>"
      },
      custom_types: %{
        "<string|atom|integer>" => MapSchema.Types.UnionTest.StringOrAtomOrIntegerType
      }
  end

  alias MapSchema.Types.UnionTest.SchemaWithUnionType

  test "valid values union" do
    obj = SchemaWithUnionType.new()
      |> SchemaWithUnionType.put_field(1)

    assert obj.field == 1

    obj = SchemaWithUnionType.new()
      |> SchemaWithUnionType.put_field(:example_of_atom)

    assert obj.field == :example_of_atom

    obj = SchemaWithUnionType.new()
      |> SchemaWithUnionType.put_field("string_example")

    assert obj.field == "string_example"
  end

  test "invalid values union" do
    try do
      _obj = SchemaWithUnionType.new()
        |> SchemaWithUnionType.put_field([1, 2, 3])

    catch
      e ->
        assert e == Exceptions.cast_error("field", "<string|atom|integer>")
    end
  end
```