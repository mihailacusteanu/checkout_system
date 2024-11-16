defmodule DiscountRuleTest do
  use ExUnit.Case

  alias CheckoutSystem.Checkout.DiscountRule
  alias CheckoutSystem.Data.DiscountRule, as: DataDiscountRule
  doctest DiscountRule

  describe "apply :get_some_free" do
    test "when you get 1 free when you order 2 items for a cart with 2 items" do
      discount_rule = %DataDiscountRule{
        product_code: "GR1",
        min_items_for_discount: 2,
        discount_strategy: %{
          type: :get_some_free,
          free_items_received: 1
        }
      }

      assert DiscountRule.apply_discount(
               _item_count = 2,
               _price = 3.11,
               discount_rule
             ) ==
               3.11
    end

    test "when you get 2 free when you order 5 items for a cart with 5 items" do
      discount_rule = %{
        product_code: "GR2",
        min_items_for_discount: 5,
        discount_strategy: %{
          type: :get_some_free,
          free_items_received: 2
        }
      }

      assert DiscountRule.apply_discount(
               _item_count = 5,
               _price = 1,
               discount_rule
             ) ==
               3
    end

    test "when you get 1 free when you order 2 items for a cart with 5 items" do
      discount_rule = %{
        product_code: "GR2",
        min_items_for_discount: 2,
        discount_strategy: %{
          type: :get_some_free,
          free_items_received: 1
        }
      }

      assert DiscountRule.apply_discount(
               _item_count = 5,
               _price = 1,
               discount_rule
             ) ==
               3
    end
  end

  describe "apply :percentage_discount" do
    test "when you get 20% discount when you order 2 items for a cart with 2 items" do
      discount_rule = %{
        product_code: "RND1",
        min_items_for_discount: 3,
        discount_strategy: %{
          type: :percentage_discount,
          percentage_discount: 20
        }
      }

      assert DiscountRule.apply_discount(
               _item_count = 2,
               _price = 3.11,
               discount_rule
             ) ==
               6.22
    end

    test "when you get 50% discount when you order 5 items for a cart with 5 items" do
      discount_rule = %{
        product_code: "RND2",
        min_items_for_discount: 3,
        discount_strategy: %{
          type: :percentage_discount,
          percentage_discount: 50
        }
      }

      assert DiscountRule.apply_discount(
               _item_count = 5,
               _price = 1,
               discount_rule
             ) ==
               2.5
    end

    test "when you get 10% discount when you order 2 items for a cart with 5 items" do
      discount_rule = %{
        product_code: "RND3",
        min_items_for_discount: 2,
        discount_strategy: %{
          type: :percentage_discount,
          percentage_discount: 10
        }
      }

      assert DiscountRule.apply_discount(
               _item_count = 5,
               _price = 1,
               discount_rule
             ) ==
               4.5
    end
  end
end
