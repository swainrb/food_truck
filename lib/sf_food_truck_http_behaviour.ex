defmodule SFFoodTruckHttpBehaviour do
  @callback get(String.t()) ::
              {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()}
              | {:error, String.t()}
end
