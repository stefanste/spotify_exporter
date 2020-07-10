class FetchAllLikedTracks
  SPOTIFY_API_ENDPOINT = "https://api.spotify.com".freeze
  MAX_TRACKS_SPOTIFY_RETURNS_PER_REQUEST = 50

  def self.call(access_token)
    new(access_token).call
  end

  def initialize(access_token)
    @access_token = access_token
    @offset = 0
    @liked_tracks = []
  end

  # Spotify endpoint returns a max of 50 tracks per request - hence the need to
  # loop with increasing @offset to retrieve them all.
  def call
    loop do
      response = RestClient.get(
        "#{SPOTIFY_API_ENDPOINT}/v1/me/tracks?#{fetch_tracks_params.to_query}",
        { 'Authorization' => "Bearer #{@access_token}" }
      )

      tracks = JSON.parse(response.body)['items']
      break if tracks.empty?

      @liked_tracks += tracks.map { |track| artist_and_song_title_for(track) }
      @offset += MAX_TRACKS_SPOTIFY_RETURNS_PER_REQUEST
      puts "Offset is currently: #{@offset}"
    end

    @liked_tracks
  end

  private

  def fetch_tracks_params
    {
      limit: MAX_TRACKS_SPOTIFY_RETURNS_PER_REQUEST,
      offset: @offset
    }
  end

  def artist_and_song_title_for(track)
    artists = track['track']['artists'].map { |artist| artist['name'] }.join(', ')
    song_title = track['track']['name']

    "#{artists} - #{song_title}"
  end
end
