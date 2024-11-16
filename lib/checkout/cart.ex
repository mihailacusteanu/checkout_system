defmodule CheckoutSystem.Checkout.Cart do
  @moduledoc """
  Module responsible for managing the cart.
  """
  alias CheckoutSystem.Checkout.DiscountRule
  alias CheckoutSystem.Data.DiscountRule, as: DataDiscountRule

  @spec calculate_total([String.t()]) :: float
  def calculate_total(list_of_product_codes) do
    case Process.whereis(:prices_and_discounts) do
      nil ->
        {:error, {:cart_calculate_total, "prices_and_discounts not initialized"}}

      _ ->
        Agent.get(
          :prices_and_discounts,
          fn %{prices: prices, discounts: discounts} ->
            list_of_product_codes
            |> generate_cart(prices)
            |> calculate_total(discounts)
          end
        )
    end
  end

  @spec calculate_total([map()], map()) :: float
  def calculate_total(cart, discount_rules) do
    Enum.reduce(cart, 0.0, fn product, acc ->
      acc + price_for_product(product, discount_rules)
    end)
    |> Float.round(2)
  end

  @spec generate_cart([String.t()], map()) :: [map()]
  def generate_cart(list_of_product_codes, prices) do
    list_of_product_codes
    |> Enum.frequencies()
    |> Enum.map(fn {product_code, item_count} ->
      %{
        item_count: item_count,
        product_code: product_code,
        price: Map.get(prices, product_code)
      }
    end)
  end

  @spec price_for_product(
          %{
            :item_count => integer(),
            :price => float(),
            :product_code => any()
          },
          [DataDiscountRule.t()]
        ) :: float()
  def price_for_product(
        %{product_code: product_code, item_count: item_count, price: price},
        discount_rules
      ) do
    discount_rule = discount_rules[product_code]

    DiscountRule.apply_discount(
      item_count,
      price,
      discount_rule
    )
  end
end
