class FetchAllLikedAlbums
  include FetchAllLikedResourceItems

  def self.call(access_token)
    new(access_token).call
  end

  def initialize(access_token)
    @access_token = access_token
    @offset = 0
    @resource = :albums
    @liked_items = []
  end
end
