defmodule NanocompilerTest do
  use Nanocompiler.TestCase, async: false

  compiler_cases "adder", [
    {"5", "5"},
    {"sub1(add1(sub1(5)))", "4"},
    {"let x = 5 in add1(x)", "6"},
    {"let x = 5, y = sub1(x) in sub1(y)", "3"}
  ]
end
