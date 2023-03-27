defmodule FoodTruck.Trucks.FoodItemsTest do
  use FoodTruck.DataCase
  alias FoodTruck.Trucks.FoodItems

  import Mox

  setup [:set_mox_global, :verify_on_exit!]

  describe "search_food_items" do
    test "can filter food items" do
      expect(FoodTruckWeb.MockSFFoodTruckHTTP, :get, fn _a ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           body: "[{\"fooditems\":\"aabb\"}\n,{\"fooditems\":\"aabc\"}\n,{\"fooditems\":\"dcc\"}]"
         }}
      end)

      assert ["aabb", "aabc"] ==
               FoodItems.search_food_items(%{"food_item" => "a"})
    end
  end
end
