defmodule FoodTruck.Repo.Migrations.AddUsersTrucksTable do
  use Ecto.Migration

  def change do
    create table(:users_trucks) do
      add :user_id, :bigint, null: false
      add :truck_id, :bigint, null: false
      add :choice_date, :date, null: false
      timestamps()

      unique_index(:users_trucks, [:user_id, :truck_id, :choice_date])
    end
  end
end
