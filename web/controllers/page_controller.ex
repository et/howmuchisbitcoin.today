defmodule CoinMarketCap do
  use HTTPoison.Base

  @expected_fields ~w(
    price_usd
  )

  def process_url(url) do
    "https://api.coinmarketcap.com/v1/" <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> List.first
    |> Map.take(@expected_fields)
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end
end

defmodule GigalixirGettingStarted.PageController do
  use GigalixirGettingStarted.Web, :controller

  def index(conn, _params) do
    CoinMarketCap.start
    price_usd = CoinMarketCap.get!("ticker/?convert=USD&limit=1").body[:price_usd]
    render conn, "index.html", price_usd: price_usd
  end
end
