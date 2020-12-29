defmodule MapSchema.JsonEncoding.WithAtomsTest do
  @moduledoc false
  use ExUnit.Case

  defmodule Object do
    @moduledoc false
    use MapSchema,
      schema: %{
        "name" => :string,
        "state" => :atom
      }
  end

  test "the atoms fields should be auto-casts in decode and encoding" do
    json = "{\"name\":\"box\",\"state\":\"in_stock\"}"
    obj = Object.json_decode(json)

    assert Object.get_name(obj) == "box"
    assert Object.get_state(obj) == :in_stock

    assert Object.json_encode(obj) == "{\"name\":\"box\",\"state\":\"in_stock\"}"
  end

end
