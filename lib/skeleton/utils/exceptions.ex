defmodule MapSchema.Exceptions do
  @moduledoc """
  The module have the exceptions functions.
  """

  def not_exist_field_in_schema(field) do
    "Schema error: the field \"#{field}\". don't exit in schema"
  end
  def throw_not_exist_field_in_schema(field) do
    throw(not_exist_field_in_schema(field))
  end

  def cast_error(field, type) do
    "Casting error: We can´t cast the value of \"#{field}\" to \"#{type}\" type. Review the type it please."
  end
  def throw_cast_error(field, type) do
    throw(cast_error(field, type) )
  end

  def type_error(field, type) do
    "Type error: the field \"#{field}\" it´s \"#{type}\". Review the type it please."
  end
  def throw_type_error(field, type) do
    throw(type_error(field, type))
  end

  def config_error_custom_types_should_be_list do
    "MapSchema error config: Custom types should be a list."
  end
  def throw_config_error_custom_types_should_be_list do
    throw(config_error_custom_types_should_be_list())
  end

  def config_error_schema_should_be_map do
    "MapSchema error config: Schema should be a map."
  end
  def throw_config_error_schema_should_be_map do
    throw(config_error_schema_should_be_map())
  end

  def config_error_atomize_schema do
    "MapSchema error config: atomize should be a boolean. Review docs before of active."
  end
  def throw_config_error_atomize_schema do
    throw(config_error_atomize_schema())
  end

  def config_atomize_schema(field) do
    "Schema caution: The #{field} is atom but the atomize flag isnt active. You can have problems with json encoding."
  end
  def throw_warn_config_atomize_schema(field) do
    #IO.warn(config_atomize_schema(field))
    # Sorry, strict mode
    throw(config_atomize_schema(field))
  end

end
