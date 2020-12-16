defmodule MapSchema.ShouldBeMapTest do
  @moduledoc false
  use ExUnit.Case
  alias MapSchema.Examples.Person
  alias MapSchema.Exceptions

  test "Should be map is_valid?" do
    try do
      Person.is_valid?(nil)
    catch
      e ->
        assert e == Exceptions.error_should_be_a_map()
    end
  end

  test "Should be map getters" do
    try do
      Person.get_name(nil)
    catch
      e ->
        assert e == Exceptions.error_should_be_a_map()
    end
  end

  test "Should be map puts" do
    try do
      Person.put_name(nil, "ric")
    catch
      e ->
        assert e == Exceptions.error_should_be_a_map()
    end
  end

  test "Should be map put general" do
    try do
      Person.put(nil)
    catch
      e ->
        assert e == Exceptions.error_should_be_a_map()
    end
  end

  test "Should be map mut" do
    try do
      Person.mut_name(nil, fn(old) -> old <> "..." end)
    catch
      e ->
        assert e == Exceptions.error_should_be_a_map()
    end
  end

  test "Should be map put_ifmatch" do
    try do
      Person.put_ifmatch(nil, %{})
    catch
      e ->
        assert e == Exceptions.error_should_be_a_map()
    end
  end

end
