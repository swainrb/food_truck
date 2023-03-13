defmodule FoodTruck.TrucksTest do
  use FoodTruck.DataCase

  alias FoodTruck.Factory
  alias FoodTruck.Trucks

  describe "get_truck_by_object_id" do
    test "does not return truck for invalid object_id" do
      refute Trucks.get_truck_by_object_id("99999999999")
    end

    test "returns truck for a valid object_id" do
      truck = Factory.insert(:truck)
      assert truck_db = Trucks.get_truck_by_object_id(truck.object_id)
      assert truck.name == truck_db.name
    end
  end
end
