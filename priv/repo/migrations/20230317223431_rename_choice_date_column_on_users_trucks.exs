defmodule FoodTruck.Repo.Migrations.RenameChoiceDateColumnOnUsersTrucks do
  use Ecto.Migration

  def change do
    rename table(:users_trucks), :choice_date, to: :selection_date
  end
end
