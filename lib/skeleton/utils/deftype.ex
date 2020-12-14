defmodule MapSchema.DefType do
  @moduledoc false

  alias MapSchema.Exceptions
  @doc """
  Args:
    type_list_name:
    type_name:
  """
  def param_config_list(type_name) do
    param_config(type_name, "list_name")
  end
  def param_config_name(type_name) do
    param_config(type_name, "name")
  end

  def param_config(type_name, deftype) do
    {type_name, []} =  Code.eval_quoted(type_name)

    cond do
      is_nil(type_name) ->
        :not_deftype
      is_bitstring(type_name) and String.length("#{type_name}") > 3 ->
        type_name
      is_atom(type_name) and String.length("#{type_name}") > 3 ->
        type_name
      true ->
        Exceptions.throw_config_error_type_name_definition(deftype)
    end
  end

end
