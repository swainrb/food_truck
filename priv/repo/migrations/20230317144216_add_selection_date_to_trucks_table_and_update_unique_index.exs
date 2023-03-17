defmodule FoodTruck.Repo.Migrations.AddSelectionDateToTrucksTableAndUpdateUniqueIndex do
  use Ecto.Migration

  def up do
    alter table(:trucks) do
      add :selection_date, :date, null: false, default: "1900-01-01"
    end

    execute "ALTER TABLE trucks ALTER COLUMN selection_date DROP DEFAULT"

    drop index(:trucks, [:object_id])

    create unique_index(:trucks, [:object_id, :selection_date])
  end

  def down do
    drop index(:trucks, [:object_id, :selection_date])

    create unique_index(:trucks, :object_id)

    alter table(:trucks) do
      remove :selection_date
    end
  end
end
