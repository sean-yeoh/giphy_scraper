defmodule GiphyScraper do
  @api_key Application.compile_env!(:giphy_scraper, :giphy_api_key)
  @endpoint "api.giphy.com/v1/gifs/search"

  def search(query) do
    query
    |> send_request
    |> parse_response
    |> build_image_list
  end

  defp send_request(query) do
    HTTPoison.get(
      @endpoint,
      [],
      params: %{api_key: @api_key, limit: 25, q: query}
    )
  end

  defp parse_response({:ok, response}) do
    {:ok, response_map} = Jason.decode(response.body)

    response_map["data"]
  end

  defp build_image_list(images) do
    Enum.map(images, fn image ->
      %GiphyImage{
        id: image["id"],
        url: image["url"],
        username: image["username"],
        title: image["title"]
      }
    end)
  end
end
