module Spotify
  class Authorize
    def self.call(current_user_profile, authorization_tokens)
      new(current_user_profile, authorization_tokens).call
    end

    def initialize(current_user_profile, authorization_tokens)
      @current_user_profile = current_user_profile
      @authorization_tokens = authorization_tokens
    end

    def call
      user = User.find_or_initialize_by(spotify_id: current_user_profile.id)

      user.spotify_display_name = current_user_profile.display_name
      user.access_token = authorization_tokens.access_token
      user.refresh_token = authorization_tokens.refresh_token
      user.save!
    end

    private

    attr_reader :current_user_profile, :authorization_tokens
  end
end