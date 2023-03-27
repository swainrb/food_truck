defmodule FoodTruckWeb.SFFoodTruckHTTP do
  alias HTTPoison
  @behaviour SFFoodTruckHttpBehaviour

  @fields [
    "objectid",
    "applicant",
    "locationdescription",
    "address",
    "fooditems",
    "latitude",
    "longitude"
  ]

  def all_food_items() do
    with {:ok, food_trucks_json} <- impl().get("$select=fooditems"),
         food_trucks_json <-
           food_trucks_json.body,
         {:ok, food_items} <- Jason.decode(food_trucks_json) do
      Enum.reduce(food_items, MapSet.new(), &split_food_items_strings(&1, &2))
    else
      {:error, %Jason.DecodeError{}} -> {:error, "Invalid json returned"}
      err -> err
    end
  end

  defp split_food_items_strings(food_items, acc) do
    Map.values(food_items)
    |> List.first()
    |> split_food_items_string()
    |> Enum.map(&String.trim(&1))
    |> MapSet.new()
    |> MapSet.union(acc)
  end

  defp split_food_items_string(food_items) do
    food_items
    |> String.downcase()
    |> String.split(~r";|:")
    |> Enum.map(&String.trim/1)
  end

  def filter_by_food_item(food_item) do
    select_fields = Enum.join(@fields, ",")

    query = "$select=#{select_fields}&$where=upper(fooditems) like'%#{String.upcase(food_item)}%'"

    with {:ok, food_trucks_json} <- impl().get(query),
         {:ok, food_trucks} <- Jason.decode(food_trucks_json.body) do
      Enum.map(food_trucks, &Map.put(&1, "fooditems", split_food_items_string(&1["fooditems"])))
    else
      {:error, %Jason.DecodeError{}} -> {:error, "Invalid json returned"}
      err -> err
    end
  end

  @impl SFFoodTruckHttpBehaviour
  def get(query) do
    with encoded_uri <-
           URI.encode("https://data.sfgov.org/resource/rqzj-sfat.json?Status=APPROVED&#{query}"),
         {:ok, result} <- HTTPoison.get(encoded_uri) do
      {:ok, result}
    else
      {:error, %HTTPoison.Error{}} -> {:error, "Could not get food trucks"}
    end
  end

  defp impl do
    Application.get_env(:food_truck, :http_adapter, FoodTruckWeb.SFFoodTruckHTTP)
  end
end
