defmodule FoodTruck.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :username, :string, null: false
    end
  end
end
