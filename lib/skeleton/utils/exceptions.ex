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

end
