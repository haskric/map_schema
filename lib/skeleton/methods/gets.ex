defmodule MapSchema.Methods.Gets do
  @moduledoc false
  @doc """
  The module have the internal functionality of the methods get
  """

  def generic_get(mapa, lista_fields) do
    get_in(mapa, lista_fields)
  end

  # The validation should be present in macros.
  #def generic_get(_, _) do
  #  Exceptions.throw_error_should_be_a_map()
  #end

end
