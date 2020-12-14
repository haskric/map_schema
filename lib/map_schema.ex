defmodule MapSchema do
  @moduledoc """
  Macro module of `MapSchema`.
  """

  alias MapSchema.Atomize
  alias MapSchema.Macros.AtomizeMode
  alias MapSchema.Macros.Base
  alias MapSchema.Macros.Check
  alias MapSchema.DefaultTypes
  alias MapSchema.Macros.JsonEncoding
  alias MapSchema.Macros.PropMethods
  alias MapSchema.Macros.PutPartial

  alias MapSchema.Macros.CustomTypes

  defmacro __using__(opts) do
    schema = Keyword.get(opts, :schema)
    list_custom_types = Keyword.get(opts, :custom_types)
    flag_atomize = Keyword.get(opts, :atomize)

    custom_types = DefaultTypes.param_config(list_custom_types)
    flag_atomize = Atomize.param_config(flag_atomize)

    base_methods = Base.install(schema)
    atomize_methods = AtomizeMode.install(flag_atomize)
    custom_types_methods = CustomTypes.install(custom_types)
    properties_methods = PropMethods.install(schema, custom_types)

    put_partial = PutPartial.install()
    json_methods = JsonEncoding.install()
    check_methods = Check.install()

    [
      base_methods,
      atomize_methods,
      custom_types_methods,
      properties_methods,
      put_partial,
      json_methods,
      check_methods
    ]
    |> List.flatten()
  end

end
