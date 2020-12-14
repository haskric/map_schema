defmodule MapSchema.TypesConfig do
  @moduledoc false

  alias MapSchema.Exceptions
  def param_config(custom_types) do
    {custom_types, []} =  Code.eval_quoted(custom_types)

    cond do
      is_nil(custom_types) or custom_types == [] ->
        %{}
      is_list(custom_types) or is_map(custom_types) ->
        custom_types
      true ->
        Exceptions.throw_config_error_custom_types_should_be_list_or_map()
    end
  end

end
