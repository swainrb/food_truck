defmodule FoodTruck.TrucksTest do
  use FoodTruck.DataCase

  alias FoodTruck.Accounts
  alias FoodTruck.Repo
  alias FoodTruck.Trucks.{Truck, UserTruck}
  alias FoodTruck.Factory
  alias FoodTruck.Trucks

  import FoodTruck.AccountsFixtures

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

  describe("get_truck_by_object_id_and_selection_date") do
    test "returns truck for a valid object_id and selection_date" do
      truck = Factory.insert(:truck)

      assert truck_db =
               Trucks.get_truck_by_object_id_and_selection_date(truck.object_id, Date.utc_today())

      assert truck.name == truck_db.name
    end

    test "does not return truck for invalid object_id" do
      refute Trucks.get_truck_by_object_id_and_selection_date(99_999_999_999, Date.utc_today())
    end

    test "does not return truck for out of bounds date" do
      truck = Factory.insert(:truck)
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

  describe "get_or_populate_truck" do
    test "returns an existing truck with an id" do
      truck = Factory.insert(:truck, object_id: @food_truck_json["objectid"])

      assert %Truck{id: id} = Trucks.get_or_populate_truck(@food_truck_json, Date.utc_today())
      assert truck.id == id
    end

    test "returns a truck struct given valid map" do
      assert truck = %Truck{} = Trucks.get_or_populate_truck(@food_truck_json, Date.utc_today())
      assert truck.id == nil
    end

    test "returns error for bad food truck map" do
      assert {:error, "Bad food truck map"} == Trucks.get_or_populate_truck(%{}, Date.utc_today())

      assert {:error, "Bad food truck map"} ==
               Trucks.get_or_populate_truck(
                 %{@food_truck_json | "longitude" => "a"},
                 Date.utc_today()
               )
    end
  end

  describe "record_truck_selection_for_user" do
    test "inserts users truck choice for existing truck" do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      truck = Factory.insert(:truck)

      assert {:ok, %UserTruck{user_id: user_id, truck_id: truck_id}} =
               Trucks.record_truck_selection_for_user(truck, token)
    end

    test "inserts truck if user exists and truck is unstored" do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      truck = Factory.build(:truck)

      assert {:ok, %UserTruck{user_id: user_id, truck_id: truck_id}} =
               Trucks.record_truck_selection_for_user(truck, token)

      assert %Truck{id: id} = Repo.get(Truck, truck_id)
    end

    test "doesn't insert truck for bad user session" do
      truck = Factory.build(:truck)
      token = :crypto.strong_rand_bytes(32)

      assert {:error, "Invalid user session"} =
               Trucks.record_truck_selection_for_user(truck, token)
    end
  end
end
