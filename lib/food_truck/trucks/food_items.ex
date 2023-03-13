defmodule FoodTruck.Trucks.FoodItems do
  use GenServer

  alias FoodTruckWeb.SFFoodTruckHTTP

  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def search_food_items(search_term) do
    GenServer.call(__MODULE__, {:search_food_items, search_term})
  end

  @impl true
  def init(_) do
    food_items = SFFoodTruckHTTP.all_food_items()
    {:ok, food_items}
  end

  @impl true
  def handle_call({:search_food_items, %{"food_item" => search_term}}, _from, food_items) do
    filtered_items =
      Enum.filter(food_items, &String.starts_with?(&1, String.downcase(search_term)))

    {:reply, filtered_items, food_items}
  end
end
