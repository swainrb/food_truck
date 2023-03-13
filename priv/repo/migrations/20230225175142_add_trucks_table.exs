defmodule FoodTruck.Repo.Migrations.AddTrucksTable do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS postgis", ""

    create table(:trucks) do
      add :object_id, :bigint, null: false
      add :name, :string, null: false
      add :location_description, :string, null: false
      add :address, :string, null: false
      add :food_items, {:array, :string}, null: false
      timestamps()
    end

    execute("SELECT AddGeometryColumn('trucks', 'location', 4326, 'POINT', 2)")

    create unique_index(:trucks, :object_id)
  end
end
