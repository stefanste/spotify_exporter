require 'rails_helper'

RSpec.describe Spotify::ApiClient do
  describe '#current_user_profile' do
    context 'when the request to Spotify is successful' do
      before do
        stub_request(:get, 'https://api.spotify.com/v1/me/')
          .with(headers: { 'Authorization'=>'Bearer access_token' })
          .to_return(body: {
            'display_name' => 'Blobby Bronzebeard',
            'id' => 'blobby_bronzebeard',
            'type' => 'user',
            'uri' => 'spotify:user:blobby_bronzebeard',
            'followers' => {},
            'external_urls' => {}
          }.to_json)
      end
      
      it 'returns a CurrentUserProfile struct containing the response data' do
        result = described_class.new(access_token: 'access_token').current_user_profile

        expect(result).to be_a Spotify::CurrentUserProfile
        expect(result.id).to eq 'blobby_bronzebeard'
        expect(result.display_name).to eq 'Blobby Bronzebeard'
      end
    end

    context 'when the request to Spotify fails' do
      before do
        stub_request(:get, 'https://api.spotify.com/v1/me/')
          .with(headers: { 'Authorization'=>'Bearer access_token' })
          .to_return(status: 500, body: "", headers: {})
      end

      it 'raises an exception' do
        expect { described_class.new(access_token: 'access_token').current_user_profile }
          .to raise_exception Spotify::ApiError
      end
    end
  end

  describe '#auth_tokens' do
    let(:auth_code) { 'auth_code' }
    let(:redirect_action) { :liked_albums }

    context 'when the request to Spotify is successful' do
      before do
        stub_request(:post, "#{SPOTIFY_BASE_ENDPOINT}/api/token")
          .with(headers: { 'Authorization' => 'Basic MDEyMzQ1Njc4OWFiY2RlZjowMTIzNDU2Nzg5YWJjZGVm' },
                body: {
                  'code' => 'auth_code',
                  'grant_type' => 'authorization_code',
                  'redirect_uri' => 'http://localhost:3004/liked_albums'
                })
          .to_return(body: { 'access_token' => 'abc', 'refresh_token' => 'def' }.to_json)
      end


      it 'returns an AuthTokens struct containing the response data' do
        result = described_class.new.auth_tokens(auth_code, redirect_action)

        expect(result).to be_a Spotify::AuthTokens
        expect(result.access_token).to eq 'abc'
        expect(result.refresh_token).to eq 'def'
      end
    end
    
    context 'when the request to Spotify fails' do
      before do
        stub_request(:post, "#{SPOTIFY_BASE_ENDPOINT}/api/token")
          .to_return(status: 500, body: "", headers: {})
      end

      it 'raises an exception' do
        expect { described_class.new.auth_tokens(auth_code, redirect_action) }
          .to raise_exception Spotify::ApiError
      end
    end
  end
end