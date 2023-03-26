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

  def populate_truck(
        %{
          "objectid" => object_id,
          "longitude" => longitude,
          "latitude" => latitude,
          "applicant" => applicant,
          "locationdescription" => location_description,
          "address" => address,
          "fooditems" => food_items
        },
        selection_date
      ) do
    with {longitude, _remainder} <- Float.parse(longitude),
         {latitude, _remainder} <- Float.parse(latitude),
         {object_id, _remainder} <- Integer.parse(object_id) do
      %__MODULE__{
        object_id: object_id,
        name: applicant,
        location_description: location_description,
        address: address,
        food_items: food_items,
        location: %Geo.Point{
          coordinates: {longitude, latitude},
          properties: %{},
          srid: 4326
        },
        selection_date: selection_date
      }
    else
      _ -> {:error, "Couldn't parse numerical values for food truck map"}
    end
  end
end
