defmodule FoodTruck.Trucks do
  import Ecto.Query, warn: false
  alias FoodTruck.Accounts.UserToken
  alias FoodTruck.Trucks.UserTruck
  alias FoodTruck.Repo

  alias FoodTruck.Trucks.Truck

  def get_truck_by_object_id(object_id) do
    Repo.get_by(Truck, object_id: object_id)
  end

  def get_truck_by_object_id_and_selection_date(object_id, selection_date \\ Date.utc_today()) do
    Repo.get_by(Truck, object_id: object_id, selection_date: selection_date)
  end

  def get_or_insert_truck(truck = %Truck{}) do
    Repo.insert(truck,
      on_conflict: :nothing
    )
  end

  def get_or_populate_truck(food_truck) do
    if truck = get_truck_by_object_id_and_selection_date(food_truck["objectid"]) do
      truck
    else
      {longitude, _remainder} = Float.parse(food_truck["longitude"])
      {latitude, _remainder} = Float.parse(food_truck["latitude"])
      {object_id, _remainder} = Integer.parse(food_truck["objectid"])

      %Truck{
        object_id: object_id,
        name: food_truck["applicant"],
        location_description: food_truck["locationdescription"],
        address: food_truck["address"],
        food_items: food_truck["fooditems"],
        location: %Geo.Point{
          coordinates: {longitude, latitude},
          properties: %{},
          srid: 4326
        },
        selection_date: Date.utc_today()
      }
    end
  end

  def record_truck_selection_for_user(truck = %Truck{}, user_token) do
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
