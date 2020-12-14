defmodule MapSchema do
  @moduledoc """
  Macro module of `MapSchema`.
  """

  alias MapSchema.Atomize
  alias MapSchema.DefaultTypes
  alias MapSchema.DefType
  alias MapSchema.TypesConfig

  alias MapSchema.Macros.AtomizeMode
  alias MapSchema.Macros.Base
  alias MapSchema.Macros.Check
  alias MapSchema.Macros.CustomTypes
  alias MapSchema.Macros.DefineType
  alias MapSchema.Macros.JsonEncoding
  alias MapSchema.Macros.PropMethods
  alias MapSchema.Macros.PutPartial



  defmacro __using__(opts) do
    schema = Keyword.get(opts, :schema)
    custom_types = Keyword.get(opts, :custom_types)
    flag_atomize = Keyword.get(opts, :atomize)
    type_name = Keyword.get(opts, :type_name)
    type_list_name = Keyword.get(opts, :type_list_name)

    #module = quote do unquote(__MODULE__) end


    type_name = DefType.param_config_name(type_name)
    type_list_name = DefType.param_config_list(type_list_name)

    custom_types = TypesConfig.param_config(custom_types)
    #custom_types = DefaultTypes.param_config(module, type_name, type_list_name, list_custom_types)
    flag_atomize = Atomize.param_config(flag_atomize)


    base_methods = Base.install(schema)
    atomize_methods = AtomizeMode.install(flag_atomize)
    type_methods = DefineType.install(type_name, type_list_name)
    custom_types_methods = CustomTypes.install(custom_types)
    properties_methods = PropMethods.install(schema, custom_types)

    put_partial = PutPartial.install()
    json_methods = JsonEncoding.install()
    check_methods = Check.install()

    [
      base_methods,
      atomize_methods,
      type_methods,
      custom_types_methods,
      properties_methods,
      put_partial,
      json_methods,
      check_methods
    ]
    |> List.flatten()
  end

end
