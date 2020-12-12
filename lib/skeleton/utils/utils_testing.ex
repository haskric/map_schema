defmodule MapSchema.Utils.Testing do
  @moduledoc """
  The module have the utils for testing
  """
  def generate_random_test_value(type) do
    get_tests_by_type(type)
    |> Enum.take_random(1)
    |> hd
  end

  defp get_tests_by_type(type) do
    case type do
      :string_to_integer ->
        ["1", "5", "10", "20", "30", "40", "50"]
        |> Enum.map(fn(text) -> {"\"#{text}\"", text} end)
      :string_to_float ->
        ["1.25", "4.54", "3.593", "11.294", "123.45"]
        |> Enum.map(fn(text) -> {"\"#{text}\"", text} end)
      :integer ->
        [1, 5, 10, 20, 30, 40, 50]
        |> Enum.map(fn(item) -> {item, item} end)
      :float ->
        [1.25, 4.54, 3.593, 11.294, 123.45]
        |> Enum.map(fn(item) -> {item, item} end)
      :string ->
        ["Madrid", "Barcelona", "Santiago", "Galicia", "Sevilla", "Santander"]
        |> Enum.map(fn(text) -> {"\"#{text}\"", "\"#{text}\""} end)
      :bool ->
        [true, false]
        |> Enum.map(fn(item) -> {item, item} end)
      :boolean ->
        [true, false]
        |> Enum.map(fn(item) -> {item, item} end)
      :map ->
        ["%{example_field: 11}",  "%{ field0: 0,  field1: 1}"]
        |> Enum.map(fn(item) -> {item, item} end)
      :list ->
        ["[1, 5, 10]", "[1.25, 4.54, 3.593]"]
        |> Enum.map(fn(item) -> {item, item} end)
      :any ->
        ["\"its_anything\""]
        |> Enum.map(fn(item) -> {item, item} end)
      _ ->
        ["\"its_anything\""]
        |> Enum.map(fn(item) -> {item, item} end)
    end
  end

end
