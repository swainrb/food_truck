defmodule FoodTruck.TrucksTest do
  use FoodTruck.DataCase

  alias FoodTruck.Repo
  alias FoodTruck.Trucks.{Truck, UserTruck}
  alias FoodTruck.Factory
  alias FoodTruck.Trucks

  import FoodTruck.AccountsFixtures

  describe "get_truck_by_object_id" do
    test "does not return truck for invalid object_id" do
      refute Trucks.get_truck_by_object_id(99_999_999_999)
    end

    test "returns truck for a valid object_id" do
      truck = Factory.insert(:truck)
      assert truck_db = Trucks.get_truck_by_object_id(truck.object_id)
      assert truck.name == truck_db.name
    end
  end

  describe "get_or_insert_truck" do
    test "inserts truck that doesn't exist" do
      truck = Factory.build(:truck)
      refute Trucks.get_truck_by_object_id(truck.object_id)

      assert {:ok, truck_db} = Trucks.get_or_insert_truck(truck)
      assert truck.name == truck_db.name
    end

    test "gets truck that does exist" do
      truck = Factory.insert(:truck)
      assert Trucks.get_truck_by_object_id(truck.object_id)

      assert {:ok, truck_db} = Trucks.get_or_insert_truck(truck)
      assert truck.name == truck_db.name
    end
  end

  describe "record_truck_selection_for_user" do
    test "inserts users truck choice for existing truck" do
      user = user_fixture()
      truck = Factory.insert(:truck)

      assert {:ok, %UserTruck{user_id: user_id, truck_id: truck_id}} =
               Trucks.record_truck_selection_for_user(user.id, truck)
    end

    test "inserts truck if user exists and truck is unstored" do
      user = user_fixture()
      truck = Factory.build(:truck)

      assert {:ok, %UserTruck{user_id: user_id, truck_id: truck_id}} =
               Trucks.record_truck_selection_for_user(user.id, truck)

      assert %Truck{id: id} = Repo.get(Truck, truck_id)
    end

    test "doesn't insert truck for unregistered user" do
      truck = Factory.build(:truck)

      assert {:error, "User not registered"} =
               Trucks.record_truck_selection_for_user(99_999_999_999, truck)
    end
  end
end
