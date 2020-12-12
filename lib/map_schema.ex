defmodule MapSchema do
  @moduledoc """
  Macro module of `MapSchema`.
  """

  alias MapSchema.Base
  alias MapSchema.Check
  alias MapSchema.JsonEncoding
  alias MapSchema.PropMethods
  alias MapSchema.PutPartial

  defmacro __using__(opts) do
    schema = Keyword.get(opts, :schema)

    IO.puts "Using MapSchema"
    base_methods = Base.install(schema)
    properties_methods = PropMethods.install(schema)

    put_partial = PutPartial.install()
    json_methods = JsonEncoding.install()
    check_methods = Check.install()

    [
      base_methods,
      properties_methods,
      put_partial,
      json_methods,
      check_methods
    ]
    |> List.flatten()
  end

end
