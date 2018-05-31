defmodule NanocompilerTest do
  use ExUnit.Case
  doctest Nanocompiler

  test "greets the world" do
    assert Nanocompiler.hello() == :world
  end
end
