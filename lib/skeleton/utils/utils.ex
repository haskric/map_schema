defmodule MapSchema.Utils do
  @moduledoc """
  The module have the utils functions.
  """

  @doc """
  Take list of fields and build a full name.
  """
  def get_field_name(lista_fields) do
    lista_fields |> Enum.join("_")
  end

end
