defmodule FoodTruck.Trucks.UserTruck do
  alias FoodTruck.Accounts.User
  alias FoodTruck.Trucks.Truck
  use Ecto.Schema

  schema "users_trucks" do
    belongs_to :user, User
    belongs_to :truck, Truck
    field :selection_date, :date

    timestamps()
  end
end
