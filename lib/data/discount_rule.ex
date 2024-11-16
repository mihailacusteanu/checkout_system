defmodule CheckoutSystem.Data.DiscountRule do
  @moduledoc """
  This module contains the data structure for discount rules.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias CheckoutSystem.Data.DiscountStrategy, as: DataDiscountStrategy

  @type t :: %__MODULE__{
          product_code: String.t(),
          min_items_for_discount: integer(),
          discount_strategy: %DataDiscountStrategy{}
        }

  @primary_key false
  embedded_schema do
    field(:product_code, :string)
    field(:min_items_for_discount, :integer)

    embeds_one(:discount_strategy, DataDiscountStrategy)
  end

  def changeset(discount_rule, params) do
    discount_rule
    |> cast(params, [:product_code, :min_items_for_discount])
    |> validate_required([:product_code, :min_items_for_discount])
    |> cast_embed(:discount_strategy, required: true)
  end
end
