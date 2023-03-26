defmodule FoodTruck.Trucks.UserTruck do
  alias FoodTruck.Repo
  alias FoodTruck.Accounts.User
  alias FoodTruck.Trucks.Truck
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_trucks" do
    belongs_to :user, User
    belongs_to :truck, Truck
    field :selection_date, :date

    timestamps()
  end

  @all_fields [:user, :truck, :selection_date]

  def changeset(user_truck, attrs \\ %{}) do
    user_truck
    |> cast(attrs, [:selection_date])
    |> validate_required([:user, :truck, :selection_date])
    |> cast_assoc(:truck, with: &FoodTruck.Trucks.Truck.changeset/2)
    |> unsafe_validate_unique([:user, :selection_date], Repo)
    |> unique_constraint([:user, :selection_date])
  end
end
