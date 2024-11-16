defmodule CheckoutSystem.Checkout.DiscountRule do
  @moduledoc """
  This module contains the discount rules that can be applied to a cart.
  """
  @doc """
  Apply the discount rule to a specific product
  ## Examples

      iex> CheckoutSystem.Checkout.DiscountRule.apply_discount(_item_count = 2, _item_price = 3.11, _discount_rule = %{min_items_for_discount: 2, discount_strategy: %{type: :get_some_free, free_items_received: 1}})
      3.11
  """

  alias CheckoutSystem.Data.DiscountRule, as: DataDiscountRule

  @type discount_rule :: DataDiscountRule.t()

  @spec apply_discount(
          item_count,
          price,
          discount_rule
        ) :: result
        when item_count: integer, price: float, result: float
  def apply_discount(
        item_count,
        price,
        %{
          min_items_for_discount: min_items_for_discount,
          discount_strategy: %{
            type: :get_some_free,
            free_items_received: free_items_received
          }
        }
      )
      when item_count >= min_items_for_discount do
    (item_count - div(item_count, min_items_for_discount) * free_items_received) * price
  end

  def apply_discount(
        item_count,
        price,
        discount_strategy: %{
          type: :get_some_free
        }
      ) do
    price * item_count
  end
end
