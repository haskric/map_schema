defmodule MapSchema.Atomize do
  @moduledoc false

  alias MapSchema.Exceptions

  def param_config(flag_atomize) do
    {flag_atomize, []} =  Code.eval_quoted(flag_atomize)

    cond do
      is_nil(flag_atomize) ->
        false
      is_boolean(flag_atomize) ->
        flag_atomize
      true ->
        Exceptions.throw_config_error_atomize_schema()
    end
  end

  #def process_field(field, false) when is_atom(field) do
  #  Exceptions.throw_warn_config_atomize_schema(field)
  #  field
  #end
  def process_field(field, true) do
    cond do
      is_atom(field) -> field
      is_bitstring(field) ->
        String.to_atom(field)
      true ->
        "#{field}"
        |> String.to_atom()
    end
  end
  def process_field(field, false) do
    field
  end

end
