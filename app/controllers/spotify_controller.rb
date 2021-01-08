class SpotifyController < ApplicationController
  include AuthorizationConcern

  before_action :handle_spotify_authorization

  def liked_tracks
    render json: FetchAllLikedTracks.call(@access_token)
  end

  def liked_albums
    render json: FetchAllLikedAlbums.call(@access_token)
  end
end
