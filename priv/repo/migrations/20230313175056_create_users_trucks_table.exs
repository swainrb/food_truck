defmodule FoodTruck.Repo.Migrations.AddUsersTrucksTable do
  use Ecto.Migration

  def change do
    create table(:users_trucks) do
      add :user_id, :bigint, null: false
      add :truck_id, :bigint, null: false
      add :selection_date, :date, null: false

      timestamps()
    end

    create unique_index(:users_trucks, [:user_id, :truck_id, :selection_date])
  end
end
