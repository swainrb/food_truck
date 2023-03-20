defmodule FoodTruck.Trucks.Truck do
  alias FoodTruck.Repo
  alias FoodTruck.Trucks.UserTruck
  use Ecto.Schema
  import Ecto.Changeset

  schema "trucks" do
    field :object_id, :integer
    field :name, :string
    field :location_description, :string
    field :address, :string
    field :food_items, {:array, :string}
    field :location, Geo.PostGIS.Geometry
    field :selection_date, :date

    has_many :users_trucks, UserTruck

    timestamps()
  end

  @all_fields [:object_id, :name, :location_description, :address, :food_items, :location]

  def changeset(truck, attrs \\ %{}) do
    truck
    |> cast(attrs, @all_fields)
    |> validate_required(@all_fields)
    |> unsafe_validate_unique([:object_id, :selection_date], Repo)
    |> unique_constraint([:object_id, :selection_date])
  end
end
