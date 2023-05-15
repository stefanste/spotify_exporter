class SpotifyController < ApplicationController
  include AuthorizationConcern

  before_action :handle_spotify_authorization

  def liked_tracks
    render json: FetchAllLikedTracks.call(params[:user_id])
  end

  def liked_albums
    render json: FetchAllLikedAlbums.call(params[:user_id])
  end
end
