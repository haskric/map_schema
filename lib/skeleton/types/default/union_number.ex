defmodule MapSchema.DefaultTypes.Union.MSchemaNumber do
  @moduledoc false
  use MapSchema.Types.TypeUnion,
    name: :number,
    types: [
      :integer, :float, :string_to_integer, :string_to_float
    ]

end
