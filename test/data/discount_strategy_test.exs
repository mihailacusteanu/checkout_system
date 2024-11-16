defmodule CheckoutSystem.Data.DiscountStrategyTest do
  use ExUnit.Case

  alias CheckoutSystem.Data.DiscountStrategy, as: DataDiscountStrategy

  describe("changeset/2") do
    test "with valid params have no error" do
      params = %{
        type: :get_some_free,
        free_items_received: 1
      }

      changeset = DataDiscountStrategy.changeset(%DataDiscountStrategy{}, params)

      assert changeset.valid?
      assert changeset.changes[:type] == :get_some_free
      assert changeset.changes[:free_items_received] == 1
    end

    test "with invalid params and apply_changes results in a valid DiscountStrategy" do
      params = %{
        type: :unknown_type,
        free_items_received: 1
      }

      changeset = DataDiscountStrategy.changeset(%DataDiscountStrategy{}, params)

      refute changeset.valid?
      assert TestHelper.traverse_errors(changeset) == %{type: ["is invalid"]}
    end
  end

  describe "validate_optional_field_based_on_type/1" do
    test "when type is :get_some_free and free_items_received is not present" do
      changeset = DataDiscountStrategy.changeset(%DataDiscountStrategy{}, %{type: :get_some_free})

      refute changeset.valid?
      assert TestHelper.traverse_errors(changeset) == %{free_items_received: ["can't be blank"]}
    end

    test "when type is :percentage_discount and free_items_received is present" do
      changeset =
        DataDiscountStrategy.changeset(%DataDiscountStrategy{}, %{
          type: :percentage_discount,
          free_items_received: 1
        })

      refute changeset.valid?
      assert TestHelper.traverse_errors(changeset) == %{percentage_discount: ["can't be blank"]}
    end

    test "when type is :price_drop" do
      changeset = DataDiscountStrategy.changeset(%DataDiscountStrategy{}, %{
        type: :price_drop,
        free_items_received: 1
      })

      refute changeset.valid?
      assert TestHelper.traverse_errors(changeset) == %{price_drop: ["can't be blank"]}
    end
  end
end
