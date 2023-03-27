defmodule FoodTruck.Trucks.TruckTest do
  use FoodTruck.DataCase

  alias FoodTruck.Trucks.Truck

  @food_truck_json %{
    "address" => "66 POTRERO AVE",
    "applicant" => "Natan's Catering",
    "fooditems" => [
      "burgers",
      "melts",
      "hot dogs",
      "burritos",
      "sandwiches",
      "fries",
      "onion rings",
      "drinks"
    ],
    "latitude" => "37.76854328902419",
    "locationdescription" =>
      "POTRERO AVE: 10TH ST \\ BRANNAN ST \\ DIVISION ST to ALAMEDA ST (1 - 99)",
    "longitude" => "-122.40849289243862",
    "objectid" => "1660523"
  }

  describe "populate_food_truck" do
    test "returns a truck struct given valid map" do
      assert truck = %Truck{} = Truck.populate_truck(@food_truck_json, Date.utc_today())
      assert truck.id == nil
    end

    test "returns error for food truck map error" do
      assert {:error, "Bad food truck map"} ==
               Truck.populate_truck(%{}, Date.utc_today())

      assert {:error, "Couldn't parse numerical values for food truck map"} ==
               Truck.populate_truck(
                 %{@food_truck_json | "longitude" => "a"},
                 Date.utc_today()
               )
    end
  end
end
