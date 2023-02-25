defmodule FoodTruckWeb.SFFoodTruckHTTP do
  alias HTTPoison
  alias IO

  @fields_map %{
    "objectid" => "object_id",
    "applicant" => "applicant",
    "facilitytype" => "facility_type",
    "locationdescription" => "location_description",
    "address" => "address",
    "fooditems" => "food_items",
    "schedule" => "schedule",
    "dayshours" => "days_hours",
    "location" => "location"
  }

  def all_food_items() do
    with {:ok, food_trucks_json} <- get_food_trucks("$select=fooditems"),
         food_trucks_json <-
           food_trucks_json.body,
         {:ok, food_items} <- Jason.decode(food_trucks_json) do
      Enum.reduce(food_items, MapSet.new(), &split_food_items_string(&1, &2))
    else
      {:error, %Jason.DecodeError{}} -> {:error, "Invalid json returned"}
      err -> err
    end
  end

  defp split_food_items_string(food_items, acc) do
    Map.values(food_items)
    |> List.first()
    |> String.downcase()
    |> String.split(~r";|:| ")
    |> Enum.map(&String.trim(&1))
    |> MapSet.new()
    |> MapSet.union(acc)
  end

  def filter_by_food_item(food_item) do
    select_fields =
      @fields_map
      |> Map.keys()
      |> Enum.join(",")

    query = "$select=#{select_fields}&$where=upper(fooditems) like'%#{String.upcase(food_item)}%'"

    with {:ok, food_trucks_json} <- get_food_trucks(query),
         food_trucks_json <-
           food_trucks_json.body,
         {:ok, food_trucks} <- Jason.decode(food_trucks_json) do
      food_trucks
    else
      {:error, %Jason.DecodeError{}} -> {:error, "Invalid json returned"}
      err -> err
    end
  end

  defp get_food_trucks(query) do
    with encoded_uri <-
           URI.encode("https://data.sfgov.org/resource/rqzj-sfat.json?Status=APPROVED&#{query}"),
         {:ok, result} <- HTTPoison.get(encoded_uri) do
      {:ok, result}
    else
      {:error, %HTTPoison.Error{}} -> {:error, "Could not get food trucks"}
    end
  end
end
