defmodule FoodTruck.Trucks do
  import Ecto.Query, warn: false
  alias FoodTruck.Accounts.{User, UserToken}
  alias FoodTruck.Trucks.{TruckSelections, UserTruck}
  alias FoodTruck.Repo

  alias FoodTruck.Trucks.Truck

  def get_truck_by_object_id_and_selection_date(object_id, selection_date),
    do: Repo.get_by(Truck, object_id: object_id, selection_date: selection_date)

  def get_user_truck_selection_for_date(user_token, selection_date \\ Date.utc_today()) do
    with {:ok, user_query} <- UserToken.verify_session_token_query(user_token),
         user = %User{} <- Repo.one(user_query) do
      Repo.one(
        from ut in UserTruck,
          where: ut.user_id == ^user.id,
          where: ut.selection_date == ^selection_date,
          join: t in assoc(ut, :truck),
          select: t
      )
    else
      nil ->
        {:error, "Invalid user session"}

      error ->
        error
    end
  end

  def record_truck_selection_for_user(food_truck, user_token, selection_date \\ Date.utc_today()) do
    with {:ok, user_query} <- UserToken.verify_session_token_query(user_token),
         user = %User{} <- Repo.one(user_query),
         truck = %Truck{} <- get_or_populate_truck(food_truck, selection_date) do
      user_truck =
        %UserTruck{user: user, truck: truck, selection_date: selection_date}
        |> UserTruck.changeset()
        |> Repo.insert(
          on_conflict: {:replace, [:truck_id]},
          conflict_target: [:user_id, :selection_date]
        )

      TruckSelections.aggregate_and_sort_truck_selections_for_date()
      |> TruckSelections.broadcast_truck_selections()

      user_truck
    else
      nil ->
        {:error, "Invalid user session"}

      error ->
        error
    end
  end

  defp get_or_populate_truck(
         %{
           "objectid" => object_id
         } = food_truck,
         selection_date
       ) do
    if truck = get_truck_by_object_id_and_selection_date(object_id, selection_date) do
      truck
    else
      Truck.populate_truck(food_truck, selection_date)
    end
  end

  defp get_or_populate_truck(_, _), do: {:error, "Bad food truck map"}
end
