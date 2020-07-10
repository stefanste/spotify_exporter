class SpotifyController < ApplicationController
  SPOTIFY_BASE_ENDPOINT = "https://accounts.spotify.com".freeze

  before_action :handle_spotify_authorization

  def liked_tracks
    render json: FetchAllLikedTracks.call(@access_token)
  end

  def liked_albums

  end

  private

  def handle_spotify_authorization
    redirect_to(authorization_url) && return unless params['code']

    response = request_access_and_refresh_tokens
    if response.code == 200
      response_body = JSON.parse(response.body)

      @access_token = response_body['access_token']
      @refresh_token = response_body['refresh_token']
    end
  end

  def request_access_and_refresh_tokens
    request_body = {
      grant_type: 'authorization_code',
      code: params['code'],
      redirect_uri: "#{SPOTIFY_EXPORTER_BASE_URL}/liked_tracks"
    }
    auth_credentials = Base64.strict_encode64("#{CLIENT_ID}:#{CLIENT_SECRET}")

    RestClient.post(
      "#{SPOTIFY_BASE_ENDPOINT}/api/token",
      request_body,
      { 'Authorization' => "Basic #{auth_credentials}" }
    )
  end

  def authorization_url
    auth_params = {
      client_id: CLIENT_ID,
      response_type: 'code',
      redirect_uri: "#{SPOTIFY_EXPORTER_BASE_URL}/liked_tracks",
      state: 123,
      scope: 'user-library-read'
    }

    "#{SPOTIFY_BASE_ENDPOINT}/authorize?#{auth_params.to_query}"
  end
end
