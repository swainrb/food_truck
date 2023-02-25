defmodule FoodTruckWeb.FoodTruckLive do
  use FoodTruckWeb, :live_view
  use Phoenix.Component

  alias IO

  alias Phoenix.LiveView.JS
  alias FoodTruck.FoodItems
  alias FoodTruckWeb.SFFoodTruckHTTP

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        form: :food_item,
        food_type: "",
        food_items: [],
        item: "",
        food_trucks: []
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Food Truck</h1>
    <div class="search">
      <.form let={f} for={@form} id="food-item-form" phx-change="suggest">
        <%= label f, :food_item %>
        <%= text_input f, :food_item, value: @food_type %>
        <%= error_tag f, :food_item %>
        <%= for item <- @food_items do %>
          <div class="suggestion" phx-click={JS.push("select_item", value: %{item: item, food_type: item})}>
            <%= item %>
          </div>
        <% end %>
      </.form>
      <h2>Trucks</h2>
      <%= for food_truck <- @food_trucks do %>
        <div class="suggestion">
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

  def handle_event("select_item", %{"item" => item, "food_type" => food_item}, socket) do
    food_trucks = SFFoodTruckHTTP.filter_by_food_item(item)

    {:noreply, assign(socket, food_type: food_item, food_items: [], food_trucks: food_trucks)}
  end
end
