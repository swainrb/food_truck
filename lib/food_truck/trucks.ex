defmodule FoodTruck.Trucks do
  import Ecto.Query, warn: false
  alias FoodTruck.Accounts.User
  alias FoodTruck.Trucks.UserTruck
  alias FoodTruck.Repo

  alias FoodTruck.Trucks.Truck

  def get_truck_by_object_id(object_id) do
    Repo.get_by(Truck, object_id: object_id)
  end

  def get_or_insert_truck(truck = %Truck{}) do
    Repo.insert(truck, on_conflict: [set: [name: truck.name]], conflict_target: :object_id)
  end

  def insert_truck_selection_for_user(user_id, truck = %Truck{}) do
    with user = %User{} <- Repo.get(User, user_id) do
      %UserTruck{user: user, truck: truck, choice_date: Date.utc_today()}
      |> Repo.insert()
    else
      nil -> {:error, "User not registered"}
    end
  end
end
