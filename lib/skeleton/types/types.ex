defmodule MapSchema.Types do
  @moduledoc """
  MapSchema.Types
  """
  alias MapSchema.Types.Default
  alias MapSchema.Exceptions


  def execute_autocast_typechecking(module_custom_type, value) do
    case cast_value(module_custom_type, value) do
      :error -> {:error_cast, nil}
      after_cast_value ->
        if check_is_valid?(module_custom_type, after_cast_value) do
          {:ok, after_cast_value}
        else
          {:error_type, nil}
        end
    end
  end

  @doc """
  Take the custom_types map of schema and try find the type,
  if dont found the module (is_nil) then search the type in default types.

  The default types always can be rewrite
  """
  def get_custom_type_module(custom_types, type) when is_map(custom_types) do
    custom_types
    |> Map.get(type)
    |> return_custom_type_module(type)
  end
  def get_custom_type_module(custom_types, type) when is_list(custom_types) do
    find_module_in_list(custom_types, type)
    |> return_custom_type_module(type)
  end

  defp find_module_in_list(list_custom_types, type) do
    list_custom_types
    |> Enum.reduce(nil, fn(module, acc) ->
      if is_nil(acc) do
        name_custom_type = apply(module, :name, [])
        if name_custom_type == type do
          module
        else
         acc
        end
      else
        acc
      end
    end)
  end

  defp return_custom_type_module(module, type) do
    if is_nil(module) do
      Default.get_default_type_module(type)
    else
      module
    end
  end

  #def cast_value(nil, value), do: value
  def cast_value(module_custom_type, value) do
    apply(module_custom_type , :cast, [value])
  catch
    _e ->
      :error
  end

  def check_is_valid?(nil, _after_cast_value), do: true
  def check_is_valid?(:error, _after_cast_value), do: false
  def check_is_valid?(module_custom_type, after_cast_value) do
    apply(module_custom_type , :is_valid?, [after_cast_value])
  catch
    _e ->
      false
  end

  def have_doctest?(custom_types, type) do
    get_doctest(custom_types, type) != :error
  end

  @doc """
  Take a type of data and returns a tuple `{testing_value, testing_result}` with the example values
  that we used in doctest.
  """
  def get_doctest(custom_types, type) do
    module_custom_type = get_custom_type_module(custom_types, type)

    if is_nil(module_custom_type) do
      :error
    else
      load_doctest(module_custom_type)
    end
  catch
    _e ->
      ## ;)
      :error
  end

  defp load_doctest(module_custom_type) do
    module_custom_type
    |> apply(:doctest_values, [])
    |> choise_random_test()
  rescue
    _e ->
      :error
  end

  defp choise_random_test([]) do
    #Exceptions.throw_error_set_of_doctest_cannot_be_empty()
    :error
  end
  defp choise_random_test(set_tests) do
    set_tests
    |> Enum.take_random(1)
    |> hd
  end

  @doc """
  The field of schema can save flexible content, if the user say that it use
  a :map, :list, or any custom type. In this cases we wont check the type of data.

  """
  def is_flexible_nested?(_custom_types, type) when is_map(type) do
    false
  end
  def is_flexible_nested?(custom_types, type) do
    case get_custom_type_module(custom_types, type) do
      nil -> false
      module_custom_type ->
        apply(module_custom_type, :nested?, [])
    end
  end

end
