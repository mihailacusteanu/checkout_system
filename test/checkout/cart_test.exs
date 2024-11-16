defmodule Checkout.CartTest do
  use ExUnit.Case

  alias CheckoutSystem.Checkout.Cart

  @discount_rules %{
    "GR1" => %{
      product_code: "GR1",
      min_items_for_discount: 2,
      discount_strategy: %{
        type: :get_some_free,
        free_items_received: 1
      }
    },
    "SR1" => %{
      product_code: "SR1",
      min_items_for_discount: 3,
      discount_strategy: %{
        type: :price_drop,
        price_drop: 4.5
      }
    },
    "CF1" => %{
      product_code: "CF1",
      min_items_for_discount: 3,
      discount_strategy: %{
        type: :percentage_discount,
        percentage_discount: 33.33
      }
    }
  }

  describe "calculate total" do
    test "when cart is empty" do
      assert Cart.calculate_total([], @discount_rules) == 0
    end
  end

  describe "calculate total when having 'get one free' discount items" do
    test "for a cart with 1 item" do
      cart = [
        %{
          item_count: 1,
          product_code: "GR1",
          name: "Green tea",
          price: 3.11
        }
      ]

      assert Cart.calculate_total(cart, @discount_rules) == 3.11
    end

    test "for a cart with 2 items" do
      cart = [
        %{
          item_count: 2,
          product_code: "GR1",
          name: "Green tea",
          price: 3.11
        }
      ]

      assert Cart.calculate_total(cart, @discount_rules) == 3.11
    end

    test "for a cart with 3 items" do
      cart = [
        %{
          item_count: 3,
          product_code: "GR1",
          name: "Green tea",
          price: 3.11
        }
      ]

      assert Cart.calculate_total(cart, @discount_rules) == 6.22
    end
  end

  describe "calculate total when having 'price drop' discount items" do
    test "for a cart with 1 item" do
      cart = [
        %{
          item_count: 1,
          product_code: "SR1",
          name: "Strawberries",
          price: 5.00
        }
      ]

      assert Cart.calculate_total(cart, @discount_rules) == 5.00
    end

    test "for a cart with 3 items" do
      cart = [
        %{
          item_count: 3,
          product_code: "SR1",
          name: "Strawberries",
          price: 5.00
        }
      ]

      assert Cart.calculate_total(cart, @discount_rules) == 13.50
    end
  end

  describe "calculate total when having 'percentage discount' discount items" do
    test "for a cart with 1 item" do
      cart = [
        %{
          item_count: 1,
          product_code: "CF1",
          name: "Coffee",
          price: 11.23
        }
      ]

      assert Cart.calculate_total(cart, @discount_rules) == 11.23
    end

    test "for a cart with 3 items" do
      cart = [
        %{
          item_count: 3,
          product_code: "CF1",
          name: "Coffee",
          price: 11.23
        }
      ]

      assert Cart.calculate_total(cart, @discount_rules) == 22.46
    end
  end

  describe "calculate total when having multiple discount items" do
    test "for a cart with 5 items" do
      cart = [
        %{
          item_count: 1,
          product_code: "GR1",
          name: "Green tea",
          price: 3.11
        },
        %{
          item_count: 1,
          product_code: "SR1",
          name: "Strawberries",
          price: 5.00
        },
        %{
          item_count: 2,
          product_code: "GR1",
          name: "Green tea",
          price: 3.11
        },
        %{
          item_count: 1,
          product_code: "CF1",
          name: "Coffee",
          price: 11.23
        }
      ]

      assert Cart.calculate_total(cart, @discount_rules) == 22.45
    end

    test "for a cart with 2 items" do
      cart = [
        %{
          item_count: 2,
          product_code: "GR1",
          name: "Green tea",
          price: 3.11
        }
      ]

      assert Cart.calculate_total(cart, @discount_rules) == 3.11
    end

    test "for a cart with 4 items" do
      cart = [
        %{
          item_count: 3,
          product_code: "SR1",
          name: "Strawberries",
          price: 5.00
        },
        %{
          item_count: 1,
          product_code: "GR1",
          name: "Green tea",
          price: 3.11
        }
      ]

      assert Cart.calculate_total(cart, @discount_rules) == 16.61
    end

    test "for a cart with another 5 items" do
      cart = [
        %{
          item_count: 1,
          product_code: "GR1",
          name: "Green tea",
          price: 3.11
        },
        %{
          item_count: 3,
          product_code: "CF1",
          name: "Coffee",
          price: 11.23
        },
        %{
          item_count: 1,
          product_code: "SR1",
          name: "Strawberries",
          price: 5.00
        }
      ]

      assert Cart.calculate_total(cart, @discount_rules) == 30.57
    end
  end

  describe "generate cart from list of products" do
    test "and succeed" do
      price = %{
        "GR1" => 3.11,
        "SR1" => 5.00,
        "CF1" => 11.23
      }

      list_of_product_codes = ["GR1", "CF1", "SR1", "CF1", "GR1", "GR1"]

      assert Cart.generate_cart(list_of_product_codes, price) == [
               %{
                 item_count: 2,
                 product_code: "CF1",
                 price: 11.23
               },
               %{
                 item_count: 3,
                 product_code: "GR1",
                 price: 3.11
               },
               %{
                 item_count: 1,
                 product_code: "SR1",
                 price: 5.00
               }
             ]
    end
  end

  describe "calculate total from a list of product code" do
    test "when prices_and_discounts is not initialized" do
      assert Cart.calculate_total(["GR1", "SR1", "CF1"]) ==
               {:error, {:cart_calculate_total, "prices_and_discounts not initialized"}}
    end

    test "when prices_and_discounts is initialized and having multiple items: GR1,SR1,GR1,GR1,CF1" do
      Agent.start_link(
        fn ->
          %{prices: %{"GR1" => 3.11, "SR1" => 5.00, "CF1" => 11.23}, discounts: @discount_rules}
        end,
        name: :prices_and_discounts
      )

      assert Cart.calculate_total(["GR1", "SR1", "GR1", "GR1", "CF1"]) == 22.45
    end

    test "when prices_and_discounts is initialized and having multiple items: GR1,GR1" do
      Agent.start_link(
        fn ->
          %{prices: %{"GR1" => 3.11, "SR1" => 5.00, "CF1" => 11.23}, discounts: @discount_rules}
        end,
        name: :prices_and_discounts
      )

      assert Cart.calculate_total(["GR1", "GR1"]) == 3.11
    end

    test "when prices_and_discounts is initialized and having multiple items: SR1,SR1,GR1,SR1" do
      Agent.start_link(
        fn ->
          %{prices: %{"GR1" => 3.11, "SR1" => 5.00, "CF1" => 11.23}, discounts: @discount_rules}
        end,
        name: :prices_and_discounts
      )

      assert Cart.calculate_total(["SR1", "SR1", "GR1", "SR1"]) == 16.61
    end

    test "when prices_and_discounts is initialized and having multiple items: GR1,CF1,SR1,CF1,CF1" do
      Agent.start_link(
        fn ->
          %{prices: %{"GR1" => 3.11, "SR1" => 5.00, "CF1" => 11.23}, discounts: @discount_rules}
        end,
        name: :prices_and_discounts
      )

      assert Cart.calculate_total(["GR1", "CF1", "SR1", "CF1", "CF1"]) == 30.57
    end
  end
end
