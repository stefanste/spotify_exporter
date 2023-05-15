module Spotify
  AuthTokens = Struct.new(:access_token, :refresh_token, :token_type, :expires_in, :scope, keyword_init: true)
  CurrentUserProfile = Struct.new(:id, :display_name, :external_urls, :followers, :href, :images, :type, :uri, keyword_init: true)

  class ApiError < StandardError
    def initialize(error_message)
      super(error_message)
    end
  end
end