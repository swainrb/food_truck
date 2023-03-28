defmodule FoodTruckWeb.SFFoodTruckHTTPTest do
  alias FoodTruckWeb.SFFoodTruckHTTP
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()

    http = Application.get_env(:food_truck, :http_adapter)
    Application.put_env(:food_truck, :http_adapter, FoodTruckWeb.SFFoodTruckHTTP)
    on_exit(fn -> Application.put_env(:food_truck, :http_adapter, http) end)
    :ok
  end

  describe "integration_tests" do
    test "GET all_food_items" do
      use_cassette "get_all_food_items" do
        food_items = SFFoodTruckHTTP.all_food_items()

        assert food_items ==
                 MapSet.new([
                   "acai bowls",
                   "al pastor camarones",
                   "and chicken sandwich",
                   "and water",
                   "avacado",
                   "bacon",
                   "bakery goods",
                   "beverages",
                   "beverages.",
                   "bonito poke bowls & various drinks",
                   "brazilian hamburgers",
                   "breakfast",
                   "burgers",
                   "burrito",
                   "burrito bowls",
                   "burritos",
                   "candy",
                   "canned beans",
                   "cappucino",
                   "carne asada",
                   "carnes (beef",
                   "carnitas",
                   "cheese sauce",
                   "chestnuts",
                   "chicken",
                   "chicken burritos",
                   "chicken salad wrap",
                   "chicken wrap",
                   "chicken wrap.",
                   "chinese rice",
                   "chips",
                   "chips & soda.",
                   "choice of meat",
                   "churros",
                   "coffee",
                   "cold beverages",
                   "cold truck",
                   "condiments",
                   "cookies",
                   "corn dog",
                   "corndogs",
                   "cow mein",
                   "crab burritos",
                   "crab rolls",
                   "desserts",
                   "donuts",
                   "drinks",
                   "eggs",
                   "espresso",
                   "everything",
                   "everything except for hot dogs",
                   "filipino fusion food",
                   "fish burritos",
                   "fresh fruit",
                   "fried burrito",
                   "fried pork)",
                   "fried rice",
                   "fries",
                   "fruit drinks",
                   "fruit juices",
                   "grilled halal meat",
                   "gyros",
                   "halal chicken over rice",
                   "halal gyro",
                   "halal gyro over rice",
                   "ham",
                   "horchata drinks.",
                   "hot chocolate",
                   "hot coffee",
                   "hot dogs",
                   "ica cream",
                   "ice cream",
                   "ice cream & waffle cones",
                   "iced coffee",
                   "ices",
                   "italian sausage",
                   "italian sausages",
                   "juice",
                   "juices",
                   "kale salad",
                   "kebabs",
                   "kickass salad",
                   "latin food",
                   "lobster burritos",
                   "lobster rolls",
                   "marinated pork",
                   "meat & drinks",
                   "melts",
                   "mexican",
                   "momo spicy noodle",
                   "multiple food trucks & food types",
                   "nachos",
                   "nachos (refried beans",
                   "nachos alambres",
                   "noodle plates",
                   "noodles",
                   "nuts",
                   "onion rings",
                   "pastries",
                   "pastry",
                   "poke bowls",
                   "pollo",
                   "popcorn",
                   "popo's noodle",
                   "pork loin",
                   "potato chips and popcorn.",
                   "potatoes",
                   "potatos w/fat dripping",
                   "pre-packaged snacks",
                   "prepackaged kettlecorn",
                   "pupusas",
                   "quesadilla",
                   "quesadillas",
                   "refreshments",
                   "ribs",
                   "rice",
                   "rice noodles",
                   "rice placet",
                   "rice plates",
                   "rice plates. various beverages.",
                   "rice plates. various beverages.chairman bao",
                   "roasted potatoes",
                   "roasted seasonal vegetables kale salad",
                   "rotisserie chicken",
                   "salad",
                   "salads",
                   "salsa fresca)",
                   "sandwich",
                   "sandwiches",
                   "sausage",
                   "sausages",
                   "senor sisig",
                   "shish-ka-bob",
                   "smoothies",
                   "snow cones",
                   "soda",
                   "soda & juice",
                   "sodas",
                   "sodea",
                   "soft drinks",
                   "soft pretzels",
                   "soft serve ice cream",
                   "soft serve ice cream & frozen virgin daiquiris",
                   "soup",
                   "soups",
                   "spicy chicken noodle",
                   "taco",
                   "tacos",
                   "tacos burritos quesadillas tortas pupusas flautas tamales",
                   "te",
                   "tea",
                   "tortas",
                   "various drinks",
                   "various drinks.",
                   "various menu items & drinks",
                   "vegan hot dogs",
                   "vegan pastries",
                   "vegan shakes",
                   "vegan tamales",
                   "vegetable and meat sandwiches filled with asian-flavored meats and vegetables.",
                   "vegetables",
                   "waffle cones",
                   "water",
                   "waters"
                 ])
      end
    end

    test "filter_by_food_item" do
      use_cassette "filter_by_food_item" do
        food_items = SFFoodTruckHTTP.filter_by_food_item("keba")

        assert food_items == [
                 %{
                   "address" => "400 MONTGOMERY ST",
                   "applicant" => "Halal Cart, LLC",
                   "fooditems" => ["kebabs", "halal gyro", "grilled halal meat", "refreshments"],
                   "latitude" => "37.79314862698347",
                   "locationdescription" =>
                     "MONTGOMERY ST: CALIFORNIA ST to SACRAMENTO ST (400 - 499)",
                   "longitude" => "-122.4025671755779",
                   "objectid" => "1660691"
                 },
                 %{
                   "address" => "1 MARKET ST",
                   "applicant" => "Halal Cart, LLC",
                   "fooditems" => ["kebabs", "halal gyro", "grilled halal meat", "refreshments"],
                   "latitude" => "37.793871507150634",
                   "locationdescription" =>
                     "MARKET ST: STEUART ST to SPEAR ST (1 - 99) -- SOUTH --",
                   "longitude" => "-122.39486523862108",
                   "objectid" => "1660690"
                 },
                 %{
                   "address" => "455 MARKET ST",
                   "applicant" => "Halal Cart, LLC",
                   "fooditems" => ["gyros", "kebabs", "soft drinks", "and water"],
                   "latitude" => "37.79094704192342",
                   "locationdescription" =>
                     "MARKET ST: FREMONT ST \\ FRONT ST to 01ST ST \\ BUSH ST (401 - 499) -- SOUTH --",
                   "longitude" => "-122.39863358940373",
                   "objectid" => "1660693"
                 }
               ]
      end
    end
  end
end
