defmodule NBPTest do
  use ExUnit.Case
  doctest NBP

  test "greets the world" do
    assert NBP.hello() == :world
  end
end
