defmodule MapSchema.CustomType do
  @moduledoc """
  Definition of MapSchema CustomType
  """

  @doc """
  Return the key name that the custom type will use

  For example:
    :language_iso639

  Like the example `MapSchema.Examples.CustomTypeLang`

  """
  @callback name :: atom | String.t()

  @doc """
  If a item it´s nested.
  You will can save for example other map into a one schema.

  Default types nested:
    :list, :map, :any

  """
  @callback nested? :: true | false

  @doc """
  Every type that you put information into a map using the schema:
  original_data -> cast -> muted_data -> is_valid? -> (ok) put in.
  in case of the cast or validation would have errors MapSchema will throw exception.

  You can return :error for reject a format.

  See the example `MapSchema.Examples.CustomTypeLang` for can take ideas
  of use.
  """
  @callback cast(value :: any) :: any | :error

  @doc """
  The validation should be return true or false.
  then you can return false for reject a value.

  """
  @callback is_valid?(value :: any) :: true | false

  @doc """
  If you implement this method well you will have doctest free for all
  the method of your schema. Yes... Sound good... ;)

  It´s important be careful because the values should be in string format for can be write it
  into the doctests please review that `mix docs` run without problems.

  This method return a list of tuples [{value_test, expected_value},{.. , ..}...]
  map schema selected a random tuple for build the test ;) Please be careful, and
  test that every tuple it´s correct. Thanks.

  See the example `MapSchema.Examples.CustomTypeLang` for can take ideas
  of use.
  """
  @callback doctest_values :: [{value :: any, expected :: any}]

end
