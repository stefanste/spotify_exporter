class FetchAllLikedAlbums
  include FetchAllLikedResourceItems

  def self.call(user_id)
    new(user_id).call
  end

  def initialize(user_id)
    @access_token = User.find_by(spotify_id: user_id).access_token
    @offset = 0
    @resource = :albums
    @liked_items = []
  end
end
