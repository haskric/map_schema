defmodule MapSchema.Methods.Gets do
  @moduledoc """
  The module have the internal functionality of the methods get
  """

  def generic_get(mapa, lista_fields) do
    get_in(mapa, lista_fields)
  end

end
