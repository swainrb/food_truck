defmodule FoodTruck.Trucks.TruckSelectionsTest do
  use FoodTruck.DataCase

  alias FoodTruck.Accounts
  alias FoodTruck.Factory
  alias FoodTruck.Trucks
  alias FoodTruck.Trucks.TruckSelections

  import FoodTruck.AccountsFixtures

  describe "aggregate_and_sort_truck_selections_for_date" do
    test "groups choices with count" do
      user1 = user_fixture()
      user2 = user_fixture()
      user3 = user_fixture()
      token1 = Accounts.generate_user_session_token(user1)
      token2 = Accounts.generate_user_session_token(user2)
      token3 = Accounts.generate_user_session_token(user3)

      truck1 = Factory.food_truck_string_params()
      truck2 = Factory.food_truck_string_params()

      {:ok, %{truck_id: truck_id1}} = Trucks.record_truck_selection_for_user(truck1, token1)
      Trucks.record_truck_selection_for_user(truck1, token2)
      {:ok, %{truck_id: truck_id2}} = Trucks.record_truck_selection_for_user(truck2, token3)

      assert [{%{id: ^truck_id1}, 2}, {%{id: ^truck_id2}, 1}] =
               TruckSelections.aggregate_and_sort_truck_selections_for_date()
    end
  end
end
