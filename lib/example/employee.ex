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
