defmodule MapSchema.Examples.Employee do
  @moduledoc """
  Person example
  """
  use MapSchema,
    schema: %{
        :name => :string,
        :surname => :string,
        :contact => %{
          :email => :string,
        }

    },
    custom_types: []

end
