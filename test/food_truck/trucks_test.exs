defmodule FoodTruck.TrucksTest do
  use FoodTruck.DataCase

  alias FoodTruck.Accounts
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

      refute Trucks.get_truck_by_object_id_and_selection_date(
               truck.object_id,
               Date.utc_today() |> Date.add(1)
             )
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
      token = Accounts.generate_user_session_token(user)
      food_truck = Factory.food_truck_string_params()

      {:ok, truck} =
        food_truck
        |> Truck.populate_truck(Date.utc_today())
        |> Repo.insert()

      assert {:ok, %UserTruck{user_id: user_id, truck_id: truck_id}} =
               Trucks.record_truck_selection_for_user(food_truck, token)

      assert user_id == user.id
      assert truck_id == truck.id
    end

    test "inserts truck if user exists and truck is unstored" do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      truck = Factory.food_truck_string_params()

      assert {:ok, %UserTruck{user_id: user_id, truck_id: truck_id}} =
               Trucks.record_truck_selection_for_user(truck, token)

      assert %Truck{id: id} = Repo.get(Truck, truck_id)
      assert user_id == user.id
      assert truck_id == id
    end

    test "doesn't insert truck for bad user session" do
      truck = Factory.food_truck_string_params()
      token = :crypto.strong_rand_bytes(32)

      assert {:error, "Invalid user session"} =
               Trucks.record_truck_selection_for_user(truck, token)
    end

    test "updates truck for user with existing selection" do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      truck1 = Factory.food_truck_string_params()
      truck2 = Factory.food_truck_string_params()

      Trucks.record_truck_selection_for_user(truck1, token)

      {:ok, %{selection_date: selection_date}} =
        Trucks.record_truck_selection_for_user(truck2, token)

      user_truck =
        Repo.one(
          from ut in UserTruck,
            where: ut.user_id == ^user.id,
            where: ut.selection_date == ^selection_date,
            preload: [:truck]
        )

      {object_id, _} = Integer.parse(truck2["objectid"])
      assert user_truck.truck.object_id == object_id
    end

    test "multiple users with the same truck selection are associated with one truck entry" do
      user1 = user_fixture()
      user2 = user_fixture()
      token1 = Accounts.generate_user_session_token(user1)
      token2 = Accounts.generate_user_session_token(user2)

      truck = Factory.food_truck_string_params()

      {:ok, %UserTruck{truck_id: truck_id1}} =
        Trucks.record_truck_selection_for_user(truck, token1)

      {:ok, %UserTruck{truck_id: truck_id2}} =
        Trucks.record_truck_selection_for_user(truck, token2)

      assert truck_id1 == truck_id2
    end

    test "the same truck selection on different days get seperate entries" do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      truck = Factory.food_truck_string_params()

      {:ok, %UserTruck{user_id: user_id1, truck_id: truck_id1}} =
        Trucks.record_truck_selection_for_user(
          truck,
          token,
          Date.utc_today() |> Date.add(-1)
        )

      {:ok, %UserTruck{user_id: user_id2, truck_id: truck_id2}} =
        Trucks.record_truck_selection_for_user(truck, token)

      assert user_id1 == user_id2
      assert truck_id1 != truck_id2
    end
  end
end
