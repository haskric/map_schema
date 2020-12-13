defmodule MapSchema.DoctestTest do
  @moduledoc false
  use ExUnit.Case
  doctest MapSchema.Examples.Person
  doctest MapSchema.Examples.TestingExample
  doctest MapSchema.Examples.CustomTypeLang
  doctest MapSchema.Examples.CustomTypeRecursive.ListPeople

end
