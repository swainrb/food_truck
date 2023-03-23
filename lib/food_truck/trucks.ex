defmodule FoodTruck.Trucks do
  import Ecto.Query, warn: false
  alias FoodTruck.Accounts.{User, UserToken}
  alias FoodTruck.Trucks.UserTruck
  alias FoodTruck.Repo

  alias FoodTruck.Trucks.Truck

  def get_truck_by_object_id(object_id) do
    Repo.get_by(Truck, object_id: object_id)
  end

  def get_truck_by_object_id_and_selection_date(object_id, selection_date) do
    Repo.get_by(Truck, object_id: object_id, selection_date: selection_date)
  end

  def get_or_insert_truck(truck = %Truck{}) do
    truck
    |> Truck.changeset()
    |> Repo.insert(on_conflict: :nothing)
  end

  def get_or_populate_truck(food_truck, selection_date \\ Date.utc_today())

  def get_or_populate_truck(
        %{
          "objectid" => object_id,
          "longitude" => longitude,
          "latitude" => latitude,
          "applicant" => applicant,
          "locationdescription" => location_description,
          "address" => address,
          "fooditems" => food_items
        },
        selection_date
      ) do
    if truck = get_truck_by_object_id_and_selection_date(object_id, selection_date) do
      truck
    else
      with {longitude, _remainder} <- Float.parse(longitude),
           {latitude, _remainder} <- Float.parse(latitude),
           {object_id, _remainder} <- Integer.parse(object_id) do
        %Truck{
          object_id: object_id,
          name: applicant,
          location_description: location_description,
          address: address,
          food_items: food_items,
          location: %Geo.Point{
            coordinates: {longitude, latitude},
            properties: %{},
            srid: 4326
          },
          selection_date: Date.utc_today()
        }
      else
        _ -> {:error, "Bad food truck map"}
      end
    end
  end

  def get_or_populate_truck(_, _) do
    {:error, "Bad food truck map"}
  end

  def record_truck_selection_for_user(truck = %Truck{}, user_token) do
    with {:ok, user_query} <- UserToken.verify_session_token_query(user_token),
         user = %User{} <- Repo.one(user_query),
         {:ok, truck} <- get_or_insert_truck(truck) do
      %UserTruck{user: user, truck: truck, selection_date: Date.utc_today()}
      |> UserTruck.changeset()
      |> Repo.insert(
        on_conflict: [set: [truck_id: truck.id]],
        conflict_target: [:user_id, :selection_date]
      )
    else
      nil ->
        {:error, "Invalid user session"}

      {:error, error} ->
        {:error, error}
    end
  end
end
