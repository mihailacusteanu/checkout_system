defmodule CheckoutSystem.Data.DiscountStrategy do
  @moduledoc """
  This module contains the data structure for discount strategies.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          type: atom(),
          free_items_received: integer()
        }

  @primary_key false
  embedded_schema do
    field(:type, Ecto.Enum, values: [:get_some_free])
    field(:free_items_received, :integer)
  end

  def changeset(strategy, params) do
    strategy
    |> cast(params, [:type, :free_items_received])
    |> validate_required([:type])
    |> validate_inclusion(:type, [:get_some_free])
  end
end
