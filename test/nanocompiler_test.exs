defmodule NanocompilerTest do
  use Nanocompiler.TestCase, async: false

  describe "adder" do
    compiler_cases("adder", [
      {"5", "5"},
      {"sub1(add1(sub1(5)))", "4"},
      {"let x = 5 in add1(x)", "6"},
      {"let x = 5, y = sub1(x) in sub1(y)", "3"},
      {"let x = let y = 10 in y in x", "10"},
      {"let x = 5, x = add1(x) in x", "6"} # Should we allow this case, rebinding a variable?
    ])

    test "unbound variable" do
      assert_error("add1(x)", "unbound", "Unbound variable 'x' in expression")
    end
  end
end
