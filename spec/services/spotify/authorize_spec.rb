require 'rails_helper'
require 'spotify/api_client'

RSpec.describe Spotify::Authorize do
  describe '.call' do
    let(:current_user_profile) { Spotify::CurrentUserProfile.new(id: 'mr_blobby', display_name: 'MrBlobby') }
    let(:auth_tokens) { Spotify::AuthTokens.new(access_token: 'abc', refresh_token: 'def') }

    it 'persists the user data and auth tokens' do
      described_class.call(current_user_profile, auth_tokens)

      user = User.find_by(spotify_id: 'mr_blobby')

      expect(user).to be_present
      expect(user.access_token).to eq 'abc'
      expect(user.refresh_token).to eq 'def'
    end
  end
end