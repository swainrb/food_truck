defmodule FoodTruck.Trucks do
  import Ecto.Query, warn: false
  alias FoodTruck.Accounts.UserToken
  alias FoodTruck.Trucks.UserTruck
  alias FoodTruck.Repo

  alias FoodTruck.Trucks.Truck

  def get_truck_by_object_id(object_id) do
    Repo.get_by(Truck, object_id: object_id)
  end

  def get_or_insert_truck(truck = %Truck{}) do
    Repo.insert(truck, on_conflict: [set: [name: truck.name]], conflict_target: :object_id)
  end

  def record_truck_selection_for_user(user_token, truck = %Truck{}) do
    with {:ok, user_query} <- UserToken.verify_session_token_query(user_token),
         user <- Repo.one(user_query) do
      %UserTruck{user: user, truck: truck, selection_date: Date.utc_today()}
      |> Repo.insert(
        on_conflict: [set: [truck_id: truck.id]],
        conflict_target: [:user_id, :truck_id, :selection_date]
      )
    else
      nil -> {:error, "User not registered"}
    end
  end
end
