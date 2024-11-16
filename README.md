# CheckoutSystem

## Used for calculating total cart value, based on a list of items (their discount rules and prices)

## Running the code
*assuming elixir and erlang is installed with the versions from .tool-versions

1. Fetch the dependecies with `mix deps.get`
2. Run iex using `iex -S mix`
3. define inside iex the discount rules:

```
discount_rules = %{
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
```
4. also define the prices
   `
   prices = %{
        "GR1" => 3.11,
        "SR1" => 5.00,
        "CF1" => 11.23
      }`
5. Update in iex the prices
   `CheckoutSystem.Checkout.Cart.update_prices(prices)`
   and the discounts
   `CheckoutSystem.Checkout.Cart.update_discounts(discount_rules)`     
6. Run in iex the examples from the *Technical evaluation*

`CheckoutSystem.Checkout.Cart.calculate_total(["GR1", "SR1", "GR1", "GR1", "CF1"])`

22.45

`CheckoutSystem.Checkout.Cart.calculate_total(["GR1", "GR1"])`

3.11

`CheckoutSystem.Checkout.Cart.calculate_total(["SR1", "SR1", "GR1", "SR1"])`

16.61

`CheckoutSystem.Checkout.Cart.calculate_total(["GR1", "CF1", "SR1", "CF1", "CF1"])`

30.57