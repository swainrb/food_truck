defmodule FoodTruck.Trucks do
  import Ecto.Query, warn: false
  alias FoodTruck.Repo

  alias FoodTruck.Trucks.Truck

  def get_truck_by_object_id(object_id) do
    Repo.get_by(Truck, object_id: object_id)
  end
end
