defmodule MapSchema.AtomizedSchemaTest do
  @moduledoc false
  use ExUnit.Case
  alias MapSchema.Examples.Employee

  test "New employee get with dot sintax" do
    emp = Employee.new()
      |> Employee.put_name("Ric")
      |> Employee.put_surname("H")
      |> Employee.put_contact_email("nested@email.com")

    assert emp.name == "Ric"
    assert Employee.get_name(emp) == "Ric"

    assert emp.surname == "H"
    assert Employee.get_surname(emp) == "H"

    assert emp.contact.email == "nested@email.com"
    assert Employee.get_contact_email(emp) == "nested@email.com"
  end

  test "Json encoding of atomize schema structure" do
    emp = Employee.new()
      |> Employee.put_name("Ric")
      |> Employee.put_surname("H")
      |> Employee.put_contact_email("nested@email.com")

    json = Employee.json_encode(emp)
    assert Employee.json_decode(json) == emp
  end

end
