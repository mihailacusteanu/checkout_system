defmodule Data.DiscountRuleTest do
  use ExUnit.Case

  describe("changeset/2") do
    test "with valid params have no error" do
      params = %{
        product_code: "PR1",
        min_items_for_discount: 2,
        discount_strategy: %{
          type: :get_some_free,
          free_items_received: 1
        }
      }

      changeset =
        CheckoutSystem.Data.DiscountRule.changeset(%CheckoutSystem.Data.DiscountRule{}, params)

      assert changeset.valid?
    end

    test "with invalid params and apply_changes results in a valid DiscountRule" do
      params = %{
        product_code: "VOUCHER",
        min_items_for_discount: 2,
        discount_strategy: %{
          type: :unknown_type,
          free_items_received: 1
        }
      }

      changeset =
        CheckoutSystem.Data.DiscountRule.changeset(%CheckoutSystem.Data.DiscountRule{}, params)

      refute changeset.valid?
      assert TestHelper.traverse_errors(changeset) == %{discount_strategy: %{type: ["is invalid"]}}
    end
  end
end
