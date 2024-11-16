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
end
