defmodule FoodTruck.Trucks.Truck do
  alias FoodTruck.Trucks.UserTruck
  use Ecto.Schema

  schema "trucks" do
    field :object_id, :integer
    field :name, :string
    field :location_description, :string
    field :address, :string
    field :food_items, {:array, :string}
    field :location, Geo.PostGIS.Geometry

    has_many :users_trucks, UserTruck

    timestamps()
  end

  @all_fields [:object_id, :name, :location_description, :address, :food_items, :location]

  # def truck_changeset(truck, attrs) do
  #   truck
  #   |> cast(attrs, @all_fields)
  #   |> validate_required(@all_fields)
  #   |> unsafe_validate_unique(:object_id, FoodTruck.Repo)
  #   |> unique_constraint(:object_id)
  # end
end
