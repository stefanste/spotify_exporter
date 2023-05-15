module Spotify
  class ApiClient 
    SPOTIFY_API_ENDPOINT = "https://api.spotify.com".freeze

    def initialize(access_token: nil)
      @access_token = access_token
    end

    def current_user_profile
      response = RestClient.get(
        "#{SPOTIFY_API_ENDPOINT}/v1/me/",
        { 'Authorization' => "Bearer #{@access_token}" }
      ) { |response, request, result| response }

      if response.code == 200
        CurrentUserProfile.new JSON.parse(response.body)
      else
        raise ApiError.new("Response status: #{response.code}, response body: #{response.body}")
      end
    end

    def auth_tokens(auth_code, redirect_action)
      request_body = {
        grant_type: 'authorization_code',
        code: auth_code,
        redirect_uri: "#{SPOTIFY_EXPORTER_BASE_URL}/#{redirect_action}"
      }
      auth_credentials = Base64.strict_encode64("#{CLIENT_ID}:#{CLIENT_SECRET}")

      response = RestClient.post(
        "#{SPOTIFY_BASE_ENDPOINT}/api/token",
        request_body,
        { 'Authorization' => "Basic #{auth_credentials}" }
      ) { |response, request, result| response }

      if response.code == 200 
        AuthTokens.new JSON.parse(response.body)
      else
        raise ApiError.new("Response status: #{response.code}, response body: #{response.body}")
      end
    end
  end
end