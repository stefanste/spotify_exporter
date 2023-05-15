module AuthorizationConcern
  def handle_spotify_authorization
    return if params[:user_id]
    redirect_to(authorization_url, allow_other_host: true) && return unless params[:code]

    auth_tokens = Spotify::ApiClient.new.auth_tokens(params[:code], params[:action])
    current_user_profile = Spotify::ApiClient.new(access_token: auth_tokens.access_token).current_user_profile
    Spotify::Authorize.call(current_user_profile, auth_tokens)

    redirect_to action: params[:action], user_id: current_user_profile.id
  end

  def authorization_url
    auth_params = {
      client_id: CLIENT_ID,
      response_type: 'code',
      redirect_uri: "#{SPOTIFY_EXPORTER_BASE_URL}/#{params[:action]}",
      state: 123,
      scope: 'user-library-read'
    }

    "#{SPOTIFY_BASE_ENDPOINT}/authorize?#{auth_params.to_query}"
  end
end