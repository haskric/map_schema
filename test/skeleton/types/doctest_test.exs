defmodule MapSchema.DefaultTypes.DoctestTest do
  @moduledoc false
  use ExUnit.Case
  doctest MapSchema.DefaultTypes.MSchemaFloat
  doctest MapSchema.DefaultTypes.MSchemaInteger
  doctest MapSchema.DefaultTypes.MSchemaString
  doctest MapSchema.DefaultTypes.MSchemaBoolean
  doctest MapSchema.DefaultTypes.MSchemaBool
  doctest MapSchema.DefaultTypes.MSchemaMap
  doctest MapSchema.DefaultTypes.MSchemaList
  doctest MapSchema.DefaultTypes.MSchemaAny

  doctest MapSchema.DefaultTypes.MSchemaStringToInteger
  doctest MapSchema.DefaultTypes.MSchemaStringToFloat

end
