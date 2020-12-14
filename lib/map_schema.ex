defmodule MapSchema do
  @moduledoc """
  Macro module of `MapSchema`.
  """

  alias MapSchema.Atomize
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

  defstruct schema: nil,
            custom_types: nil,
            flag_atomize: nil,
            type_name: nil,
            type_list_name: nil

  defmacro __using__(opts) do
    params(opts)
    |> install()
  end

  defp params(opts) do
    schema = Keyword.get(opts, :schema)
    custom_types = Keyword.get(opts, :custom_types)
    flag_atomize = Keyword.get(opts, :atomize)
    type_name = Keyword.get(opts, :type_name)
    type_list_name = Keyword.get(opts, :type_list_name)

    type_name = DefType.param_config_name(type_name)
    type_list_name = DefType.param_config_list(type_list_name)
    custom_types = TypesConfig.param_config(custom_types)
    flag_atomize = Atomize.param_config(flag_atomize)

    %MapSchema{
      schema: schema,
      custom_types: custom_types,
      flag_atomize: flag_atomize,
      type_name: type_name,
      type_list_name: type_list_name
    }
  end

  defp install(config) do
    base_methods = Base.install(config.schema)
    atomize_methods = AtomizeMode.install(config.flag_atomize)
    type_methods = DefineType.install(config.type_name, config.type_list_name)
    custom_types_methods = CustomTypes.install(config.custom_types)
    properties_methods = PropMethods.install(config.schema, config.custom_types)

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
