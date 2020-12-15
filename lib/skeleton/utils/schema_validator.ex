defmodule MapSchema.SchemaValidator do
  @moduledoc false

  alias MapSchema.Exceptions
  def check_config(schema, flag_atomize) do
    {my_schema, []} =  Code.eval_quoted(schema)

    if is_map(my_schema) do
      if is_valid?(my_schema, flag_atomize) do
        :ok
      else
        report_error_schema(flag_atomize)
      end
    else
      Exceptions.throw_config_error_schema_should_be_map()
    end
  end

  def is_valid?(my_schema, flag_atomize) do
    if flag_atomize do
      should_be_all_atom(my_schema)
    else
      should_be_all_string(my_schema)
    end
  end

  def report_error_schema(flag_atomize) do
    if flag_atomize do
      Exceptions.throw_config_schema_error_the_fields_should_be_atom()
    else
      Exceptions.throw_config_schema_error_the_fields_should_be_string()
    end
  end

  def should_be_all(my_schema, check_fn) do
    my_schema
    |> Map.keys()
    |> Enum.map(fn(key) -> check_fn.(key) end)
    |> Enum.all?
  end

  def should_be_all_atom(my_schema) do
    should_be_all(my_schema, fn(key) -> is_atom(key) end)
  end

  def should_be_all_string(my_schema) do
    should_be_all(my_schema, fn(key) -> is_bitstring(key) end)
  end

end
