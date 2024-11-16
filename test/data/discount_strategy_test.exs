defmodule CheckoutSystem.Data.DiscountStrategyTest do
  use ExUnit.Case

  alias CheckoutSystem.Data.DiscountStrategy, as: DataDiscountStrategy

  describe("changeset/2") do
    test "with valid params have no error" do
      params = %{
        type: :get_some_free,
        free_items_received: 1
      }

      changeset = DataDiscountStrategy.changeset(%DataDiscountStrategy{}, params)

      assert changeset.valid?
      assert changeset.changes[:type] == :get_some_free
      assert changeset.changes[:free_items_received] == 1
    end

    test "with invalid params and apply_changes results in a valid DiscountStrategy" do
      params = %{
        type: :unknown_type,
        free_items_received: 1
      }

      changeset = DataDiscountStrategy.changeset(%DataDiscountStrategy{}, params)

      refute changeset.valid?
      assert TestHelper.traverse_errors(changeset) == %{type: ["is invalid"]}
    end
  end
end
