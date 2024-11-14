defmodule CheckoutSystemTest do
  use ExUnit.Case
  doctest CheckoutSystem

  test "greets the world" do
    assert CheckoutSystem.hello() == :world
  end
end
