module FetchAllLikedResourceItems
  SPOTIFY_API_ENDPOINT = "https://api.spotify.com".freeze
  MAX_ITEMS_SPOTIFY_RETURNS_PER_REQUEST = 50

  # Spotify returns a max of 50 items per resource fetch request - hence the need to
  # loop with increasing @offset to retrieve them all.
  def call
    loop do
      response = RestClient.get(
        "#{SPOTIFY_API_ENDPOINT}/v1/me/#{@resource}?#{fetch_resource_params.to_query}",
        { 'Authorization' => "Bearer #{@access_token}" }
      )

      items = JSON.parse(response.body)['items']
      break if items.empty?

      @liked_items += items.map { |item| artist_and_title_for(item) }
      @offset += MAX_ITEMS_SPOTIFY_RETURNS_PER_REQUEST
      puts "Offset is currently: #{@offset}"
    end

    @liked_items
  end

  def fetch_resource_params
    {
      limit: MAX_ITEMS_SPOTIFY_RETURNS_PER_REQUEST,
      offset: @offset
    }
  end

  def artist_and_title_for(item)
    item_type = @resource.to_s.singularize

    artists = item[item_type]['artists'].map { |artist| artist['name'] }.join(', ')
    item_title = item[item_type]['name']

    "#{artists} - #{item_title}"
  end
end
