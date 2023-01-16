defmodule FoodTruck.Repo do
  use Ecto.Repo,
    otp_app: :food_truck,
    adapter: Ecto.Adapters.Postgres
end
