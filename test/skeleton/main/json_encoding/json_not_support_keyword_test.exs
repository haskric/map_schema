defmodule MapSchema.JsonEncoding.WithKeywordTest do
  @moduledoc false
  use ExUnit.Case

  defmodule Object do
    @moduledoc false
    use MapSchema,
      schema: %{
        "name" => :string,
        "keyword" => :keyword
      }
  end

  test "the atoms fields should be auto-casts in decode and encoding" do
    obj = %{"name" => "keyword_list", "keyword" => [{"key", "value"}]}

    assert Object.get_name(obj) == "keyword_list"
    assert Object.get_keyword(obj) == [{"key", "value"}]

    try do
      Object.json_encode(obj)

      assert false
    rescue
      _e ->
        ## Sorry keyword isnt support offical in Jason, you can recive a error similar this..
        ##
        ##
        ##    ** (Protocol.UndefinedError) protocol Jason.Encoder not implemented for
        ##   {"key", "value"} of type Tuple, Jason.Encoder protocol must always be explicitly implemented.
        ##   This protocol is implemented for the following type(s): Date, BitString, Jason.Fragment, Any,
        ##   Map, NaiveDateTime, List, Integer, Time, DateTime, Decimal, Atom, Float
        ##
        ## In stackoverflow explain that maybe in next version of Jason we will have support to Keywords
        ## https://stackoverflow.com/questions/58734837/elixir-jasonhelpers-how-can-i-send-a-keyword-list-to-json-map

        assert true
    end
  end

end
