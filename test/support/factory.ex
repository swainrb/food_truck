defmodule FoodTruck.Factory do
  use ExMachina.Ecto, repo: FoodTruck.Repo

  def truck_factory do
    %FoodTruck.Trucks.Truck{
      object_id: sequence(:object_id, & &1),
      name: sequence(:food_truck_name, &"food truck #{&1}"),
      location_description: "BRANNAN ST: 04TH ST to 05TH ST (500 - 599)",
      address: "525 BRANNAN ST",
      food_items: ["Tacos", "Burritos", "Quesadillas", "Tortas"],
      location: %Geo.Point{
        coordinates: {-122.40689189299718, 37.786856111883054},
        properties: %{},
        srid: 4326
      },
      selection_date: Date.utc_today()
    }
  end

  def food_truck_string_params(params \\ %{}) do
    :truck
    |> __MODULE__.string_params_for(params)
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      cond do
        key == "name" ->
          Map.put(acc, "applicant", value)

        key == "location" ->
          {latitude, longitude} = value["coordinates"]

          acc
          |> Map.put("longitude", Float.to_string(longitude))
          |> Map.put("latitude", Float.to_string(latitude))

        key == "object_id" ->
          Map.put(acc, "objectid", Integer.to_string(value))

        true ->
          Map.put(acc, String.replace(key, "_", ""), value)
      end
    end)
  end
end
