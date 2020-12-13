defmodule MapSchema.CustomType do

  @callback name :: atom
  @callback nested? :: true | false

  @callback cast(value :: any) :: any | :error

  @callback is_valid?(value :: any) :: true | false

  @callback doctest_values :: [{value :: any, expected :: any}]

end
