defmodule MapSchema.Examples.CustomTypeRecursive.ListPeople do
  @moduledoc """
  List type

  Recursive List of people using Person map_schema
  """
  @behaviour MapSchema.CustomType

  alias MapSchema.Examples.Person

  @spec name :: atom
  def name, do: :list_people
  def nested?, do: true

  @doc """
  We take a list of people and we need cast each person creating a new map that will be checked
  with the schema of Person.

  ## Example:

      iex> alias MapSchema.Examples.CustomTypeRecursive.ListPeople
      iex> lista_friends = [%{"name"=> "bob"},%{"name"=>"mary"}]
      iex> ListPeople.cast(lista_friends)
      [%{"name"=> "bob"},%{"name"=>"mary"}]

      iex> alias MapSchema.Examples.CustomTypeRecursive.ListPeople
      iex> lista_friends = [%{"name"=> "bob"},%{"name"=> 222}]
      iex> ListPeople.cast(lista_friends)
      :error

  """
  @spec cast(value :: any) :: any | :map_schema_type_error | :error
  def cast(list_people) do
    list_people
    |> Enum.map(fn(person) ->
      #Person.put_ifmatch(person) or
      Person.put(person)
    end)
  catch
    _e ->
      :error
  end

  @doc """
  If the cast it´s right then always will be valid.
  because we are using a schema then is_valid? is always true
  """
  @spec is_valid?(any) :: boolean
  def is_valid?(_value), do: true

  @doc """
    ## Example:

      iex> alias MapSchema.Examples.CustomTypeRecursive.ListPeople
      iex> ListPeople.doctest_values()
      [{"[%{\\"name\\"=> \\"bob\\"},%{\\"name\\"=>\\"mary\\"}]","[%{\\"name\\"=> \\"bob\\"},%{\\"name\\"=>\\"mary\\"}]"}]
  """
  @spec doctest_values :: [{any, any}]
  def doctest_values do
    ["[%{\"name\"=> \"bob\"},%{\"name\"=>\"mary\"}]"]
    |> Enum.map(fn(item) -> {item, item} end)
  end

end
