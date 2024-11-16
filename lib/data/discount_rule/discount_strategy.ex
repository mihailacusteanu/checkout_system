defmodule CheckoutSystem.Data.DiscountStrategy do
  @moduledoc """
  This module contains the data structure for discount strategies.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          type: atom(),
          free_items_received: integer(),
          percentage_discount: float(),
          price_drop: float()
        }

  @discount_types [:get_some_free, :percentage_discount, :price_drop]
  @discount_types_and_related_fields %{
    get_some_free: [:free_items_received],
    percentage_discount: [:percentage_discount],
    price_drop: [:price_drop]
  }

  @primary_key false
  embedded_schema do
    field(:type, Ecto.Enum, values: @discount_types)
    field(:free_items_received, :integer)
    field(:percentage_discount, :float)
    field(:price_drop, :float)
  end

  def changeset(strategy, params) do
    strategy
    |> cast(params, [:type, :free_items_received])
    |> validate_required([:type])
    |> validate_inclusion(:type, @discount_types)
    |> validate_optional_field_based_on_type()
  end

  defp validate_optional_field_based_on_type(changeset) do
    type = get_change(changeset, :type)

    if type in Map.keys(@discount_types_and_related_fields) do
      changeset
      |> validate_required(@discount_types_and_related_fields[type])
    else
      changeset
    end
  end
end
