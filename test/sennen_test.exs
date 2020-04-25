defmodule SennenTest do
  use ExUnit.Case
  doctest Sennen

  test "greets the world" do
    assert Sennen.hello() == :world
  end
end
