defmodule CheckoutSystem.Checkout.Cart do
  @moduledoc """
  Module responsible for managing the cart.
  """
  alias CheckoutSystem.Checkout.DiscountRule

  @spec calculate_total([map()], map()) :: float
  def calculate_total(cart, discount_rules) do
    Enum.reduce(cart, 0.0, fn product, acc ->
      acc + price_for_product(product, discount_rules)
    end)
    |> Float.round(2)
  end

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
