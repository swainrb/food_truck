import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :pbkdf2_elixir, :rounds, 1

config :food_truck,
  http_adapter: FoodTruckWeb.MockSFFoodTruckHTTP

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :food_truck, FoodTruck.Repo,
  username: "postgres",
  password: "password",
  hostname: "localhost",
  database: "food_truck_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10,
  types: FoodTruck.PostgresTypes

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :food_truck, FoodTruckWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "z05ebDhCOzACmM4/GByCFCoQX5EisYJnSS06Z14/o5GHhNdnflVSGtwgmUqHA2Nu",
  server: false

# In test we don't send emails.
config :food_truck, FoodTruck.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
