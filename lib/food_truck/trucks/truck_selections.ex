defmodule FoodTruck.Trucks.TruckSelections do
  import Ecto.Query, warn: false
  alias FoodTruck.Repo
  alias FoodTruck.Trucks.UserTruck

  @topic "truck_selections"

  def broadcast_truck_selections(selections),
    do: Phoenix.PubSub.broadcast(FoodTruck.PubSub, @topic, {:update_truck_selections, selections})

  def aggregate_and_sort_truck_selections_for_date(selection_date \\ Date.utc_today()) do
    Repo.all(
      from ut in UserTruck,
        where: ut.selection_date == ^selection_date,
        preload: [:truck]
    )
    |> Enum.reduce(%{}, fn user_truck, acc ->
      truck = user_truck.truck

      if truck_count = acc[truck] do
        %{acc | truck => truck_count + 1}
      else
        Map.put(acc, truck, 1)
      end
    end)
    |> Enum.sort_by(&elem(&1, 1), :desc)
  end

  def topic, do: @topic
end
