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
end
