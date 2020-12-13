defmodule MapSchema.ExuString do
  @moduledoc """
  Elixir UnOfficial Extension of String module
  """

  @doc """
  Parse string to Integer

  ### Why is interesting
  This method let you cast fast a String to integer without require use a official Integer.parse/2
  that return a tuple. This method return an integer number or :error.

  ### Target of proposal
  Keep simple code

  ## Examples
      iex> MapSchema.ExuString.to_integer!(1)
      1

      iex> MapSchema.ExuString.to_integer!("1")
      1

      iex> MapSchema.ExuString.to_integer!("-1")
      -1

      iex> MapSchema.ExuString.to_integer!("10.0")
      :error

      iex> MapSchema.ExuString.to_integer!("10.1")
      :error

      iex> MapSchema.ExuString.to_integer!("invalid_integer")
      :error

      iex> MapSchema.ExuString.to_integer!(:invalid_string)
      :error

      iex> ["1","3","invalid"] |> Enum.map(&MapSchema.ExuString.to_integer!(&1))
      [1,3,:error]

  """
  @spec to_integer!(value ::String.t) :: integer | :error
  def to_integer!(value) when is_integer(value) do
    value
  end
  def to_integer!(value) when is_bitstring(value) do
    if String.contains?(value, ".") do
      :error
    else
      case Integer.parse(value) do
        {valor, ""} -> valor
        _ -> :error
      end
    end
  rescue
    _ -> :error
  end
  def to_integer!(_), do: :error

  @doc """
  Check if a string is integer

  ### Why is interesting
  This method let you check a String is integer.

  ### Target of proposal
  Keep simple code

  ## Examples

      iex> MapSchema.ExuString.is_integer?("1")
      true

      iex> MapSchema.ExuString.is_integer?("-1")
      true

      iex> MapSchema.ExuString.is_integer?("10.0")
      false

      iex> MapSchema.ExuString.is_integer?("10.1")
      false

      iex> MapSchema.ExuString.is_integer?("invalid_integer")
      false

      iex> MapSchema.ExuString.is_integer?(:invalid_string)
      false

      iex> ["1","3","invalid"] |> Enum.all?(&MapSchema.ExuString.is_integer?(&1))
      false

  """
  @spec is_integer?(value ::String.t) :: boolean
  def is_integer?(value) do
    to_integer!(value) != :error
  end

  @doc """
  Parse string to Float

  ### Why is interesting
  This method let you cast fast a String to float without require use a official Float.parse/2
  that return a tuple. This method return an float number or :error

  ### Target of proposal
  Keep simple code

  ## Examples
      iex> MapSchema.ExuString.to_float!(1.0)
      1.0

      iex> MapSchema.ExuString.to_float!("1")
      :error

      iex> MapSchema.ExuString.to_float!("-0.10")
      -0.10

      iex> MapSchema.ExuString.to_float!("10.0000000")
      10.0

      iex> MapSchema.ExuString.to_float!("10.1")
      10.1

      iex> MapSchema.ExuString.to_float!("invalid_float")
      :error

      iex> MapSchema.ExuString.to_float!(:invalid_string)
      :error

      iex> ["1.1","3.3","invalid"] |> Enum.map(&MapSchema.ExuString.to_float!(&1))
      [1.1,3.3,:error]

  """
  @spec to_float!(value ::String.t ) :: float | :error
  def to_float!(value) when is_float(value) do
    value
  end
  def to_float!(value) when is_bitstring(value) do
    if String.contains?(value, ".") do
      case Float.parse(value) do
        {valor, ""} -> valor
        _ -> :error
      end
    else
      :error
    end
  rescue
    _ -> :error
  end
  def to_float!(_), do: :error

  @doc """
  Check if a string is float

  ### Why is interesting
  This method let you check a String is float.

  ### Target of proposal
  Keep simple code

  ## Examples

      iex> MapSchema.ExuString.is_float?("1")
      false

      iex> MapSchema.ExuString.is_float?("-0.10")
      true

      iex> MapSchema.ExuString.is_float?("10.0000000")
      true

      iex> MapSchema.ExuString.is_float?("10.1")
      true

      iex> MapSchema.ExuString.is_float?("invalid_float")
      false

      iex> MapSchema.ExuString.is_float?(:invalid_string)
      false

      iex> ["1.2","3.1","invalid"] |> Enum.all?(&MapSchema.ExuString.is_float?(&1))
      false

  """
  @spec is_float?(value :: String.t) :: boolean
  def is_float?(value) do
    to_float!(value) != :error
  end

end
