defmodule FoodTruckWeb.FoodTruckLive do
  use FoodTruckWeb, :live_view
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  alias FoodTruck.Trucks
  alias FoodTruck.Trucks.{FoodItems, Truck}
  alias FoodTruckWeb.SFFoodTruckHTTP

  def mount(_params, session, socket) do
    socket =
      assign(socket,
        form: :food_item,
        food_type: "",
        food_items: [],
        item: "",
        food_trucks: [],
        your_selection: nil,
        user_token: session["user_token"]
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Food Truck</h1>
    <h2>Your Selection</h2>
      <%= if @your_selection do %>
        <div class="selection">
          <div><h3><%= @your_selection["applicant"] %></h3></div>
          <div><h4><%= @your_selection["address"] %></h4></div>
          <div><%= @your_selection["fooditems"] %></div>
        </div>
      <% end %>
    <div class="search">
      <.form let={f} for={@form} id="food-item-form" phx-change="suggest">
        <%= label f, :food_item %>
        <%= text_input f, :food_item, value: @food_type %>
        <%= error_tag f, :food_item %>
        <%= for item <- @food_items do %>
          <div class="selection" phx-click={JS.push("select_food_item", value: %{item: item, food_type: item})}>
            <%= item %>
          </div>
        <% end %>
      </.form>
      <h2>Trucks</h2>
      <%= for food_truck <- @food_trucks do %>
        <div class="selection" phx-click={JS.push("select_food_truck", value: %{food_truck: food_truck})}>
          <div><h3><%= food_truck["applicant"] %></h3></div>
          <div><h4><%= food_truck["address"] %></h4></div>
          <div><%= food_truck["fooditems"] %></div>
        </div>
      <% end %>
    </div>
    """
  end

  def handle_event("suggest", %{"food_item" => %{"food_item" => ""}}, socket) do
    {:noreply, assign(socket, food_type: "", food_items: [])}
  end

  def handle_event("suggest", %{"food_item" => food_item}, socket) do
    food_item_list = FoodItems.search_food_items(food_item)
    {:noreply, assign(socket, food_type: food_item["food_item"], food_items: food_item_list)}
  end

  def handle_event("select_food_item", %{"item" => item, "food_type" => food_item}, socket) do
    food_trucks = SFFoodTruckHTTP.filter_by_food_item(item)

    {:noreply, assign(socket, food_type: food_item, food_items: [], food_trucks: food_trucks)}
  end

  def handle_event("select_food_truck", %{"food_truck" => food_truck}, socket) do
    {longitude, _remainder} = Float.parse(food_truck["longitude"])
    {latitude, _remainder} = Float.parse(food_truck["latitude"])
    {object_id, _remainder} = Integer.parse(food_truck["objectid"])

    truck = %Truck{
      object_id: object_id,
      name: food_truck["applicant"],
      location_description: food_truck["locationdescription"],
      address: food_truck["address"],
      food_items: food_truck["fooditems"],
      location: %Geo.Point{
        coordinates: {longitude, latitude},
        properties: %{},
        srid: 4326
      }
    }

    Trucks.record_truck_selection_for_user(socket.assigns.user_token, truck)
    {:noreply, assign(socket, your_selection: food_truck)}
  end
end
