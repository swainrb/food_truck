defmodule FoodTruckWeb.FoodTruckLive do
  use FoodTruckWeb, :live_view
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  alias FoodTruck.Trucks
  alias FoodTruck.Trucks.{FoodItems, TruckSelections}
  alias FoodTruckWeb.SFFoodTruckHTTP

  @impl true
  def mount(_params, session, socket) do
    user_token = session["user_token"]
    user_selection = Trucks.get_user_truck_selection_for_date(user_token)
    all_selections = TruckSelections.aggregate_and_sort_truck_selections_for_date()

    socket =
      assign(socket,
        form: :food_item,
        food_type: "",
        food_items: [],
        item: "",
        food_trucks: [],
        your_selection: user_selection,
        user_token: user_token,
        truck_selections: all_selections
      )

    Phoenix.PubSub.subscribe(FoodTruck.PubSub, TruckSelections.topic())
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Food Truck</h1>
    <h2>Your Selection</h2>
      <%= if @your_selection do %>
        <div class="selection">
          <div><h3><%= @your_selection.name %></h3></div>
          <div><h4><%= @your_selection.address %></h4></div>
          <div><%= Enum.join(@your_selection.food_items, ", ") %></div>
        </div>
      <% end %>
    <h2>Selections</h2>
    <%= for {food_truck, number_of_selections} <- @truck_selections do %>
        <div class="selection">
          <div><h3 align="right"><%= number_of_selections %></h3></div>
          <div><h3><%= food_truck.name %></h3></div>
          <div><h4><%= food_truck.address %></h4></div>
          <div><%= Enum.join(food_truck.food_items, ", ") %></div>
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
          <div><%= Enum.join(food_truck["fooditems"], ", ") %></div>
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
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
    truck = Trucks.record_truck_selection_for_user(food_truck, socket.assigns.user_token)

    {:noreply, assign(socket, your_selection: truck)}
  end

  @impl true
  def handle_info({:update_truck_selections, selections}, socket) do
    {:noreply, assign(socket, :truck_selections, selections)}
  end
end
