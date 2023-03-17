defmodule FoodTruckWeb.SFFoodTruckHTTPTest do
  alias FoodTruckWeb.SFFoodTruckHTTP
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  import FoodTruckWeb.SFFoodTruckHTTP

  setup_all do
    HTTPoison.start()
    :ok
  end

  test "GET all_food_items" do
    use_cassette "get_all_food_items" do
      food_items = SFFoodTruckHTTP.all_food_items()

      assert food_items ==
               MapSet.new([
                 "salad",
                 "eggs",
                 "horchata",
                 "nachos",
                 "meats",
                 "waters",
                 "soft",
                 "pastry",
                 "kale",
                 "ice",
                 "tortas",
                 "pastor",
                 "popcorn.",
                 "trucks",
                 "meat",
                 "rotisserie",
                 "corn",
                 "various",
                 "canned",
                 "ices",
                 "sandwich",
                 "items",
                 "beverages",
                 "kebabs",
                 "shish-ka-bob",
                 "types",
                 "hot",
                 "te",
                 "kettlecorn",
                 "cookies",
                 "al",
                 "asada",
                 "italian",
                 "serve",
                 "noodles",
                 "salads",
                 "juices",
                 "bacon",
                 "acai",
                 "seasonal",
                 "pollo",
                 "dripping",
                 "everything",
                 "iced",
                 "quesadillas",
                 "cappucino",
                 "fusion",
                 "camarones",
                 "burrito",
                 "tea",
                 "breakfast",
                 "candy",
                 "taco",
                 "rice",
                 "filipino",
                 "of",
                 "dogs",
                 "burgers",
                 "pork)",
                 "cow",
                 "fries",
                 "chocolate",
                 "and",
                 "frozen",
                 "smoothies",
                 "alambres",
                 "mein",
                 "beverages.chairman",
                 "rings",
                 "shakes",
                 "multiple",
                 "w/fat",
                 "sausage",
                 "choice",
                 "salsa",
                 "gyros",
                 "menu",
                 "pre-packaged",
                 "condiments",
                 "poke",
                 "chestnuts",
                 "sandwiches",
                 "espresso",
                 "popcorn",
                 "brazilian",
                 "sodas",
                 "refreshments",
                 "mexican",
                 "drinks.",
                 "kickass",
                 "virgin",
                 "drinks",
                 "bonito",
                 "vegetables",
                 "bakery",
                 "cold",
                 "gyro",
                 "sodea",
                 "pretzels",
                 "carnitas",
                 "corndogs",
                 "carnes",
                 "melts",
                 "",
                 "fresca)",
                 "except",
                 "hamburgers",
                 "ribs",
                 "water",
                 "truck",
                 "over",
                 "soup",
                 "plates",
                 "fried",
                 "soups",
                 "momo",
                 "goods",
                 "grilled",
                 "flautas",
                 "ica",
                 "loin",
                 "tacos",
                 "chicken",
                 "wrap.",
                 "soda.",
                 "donuts",
                 "potato",
                 "noodle",
                 "asian-flavored",
                 "vegetables.",
                 "burritos",
                 "bao",
                 "food",
                 "(beef",
                 "spicy",
                 "avacado",
                 "fruit",
                 "quesadilla",
                 "pork",
                 "churros",
                 "crab",
                 "with",
                 "desserts",
                 "popo's",
                 "latin",
                 "coffee",
                 "roasted",
                 "daiquiris",
                 "juice",
                 "&",
                 "lobster",
                 "sauce",
                 "carne",
                 "tamales",
                 "soda",
                 "bowls",
                 "filled",
                 "fish",
                 "waffle",
                 "snacks",
                 "beverages.",
                 "plates.",
                 "chips",
                 "potatos",
                 "nuts",
                 "pastries",
                 "snow",
                 "placet",
                 "senor",
                 "wrap",
                 "ham",
                 "pupusas",
                 "cones",
                 "dog",
                 "cheese",
                 "halal",
                 "vegan",
                 "rolls",
                 "chinese",
                 "potatoes",
                 "vegetable",
                 "beans",
                 "sisig",
                 "sausages",
                 "marinated",
                 "onion",
                 "prepackaged",
                 "for",
                 "fresh",
                 "(refried",
                 "cream"
               ])
    end
  end
end