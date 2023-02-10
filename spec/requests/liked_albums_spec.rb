require 'rails_helper'

RSpec.describe "Retrieving a user's liked albums", type: :request do
  before do
    stub_request(:post, "#{SPOTIFY_BASE_ENDPOINT}/api/token")
      .to_return(body: { 'access_token' => 'abc', 'refresh_token' => 'def' }.to_json)

    stub_request(:get, 'https://api.spotify.com/v1/me/albums?limit=50&offset=0')
      .to_return(body: {
        items: [
          {
            'album' => {
              'artists' => [{ 'name' => 'Metallica' }],
              'name' => 'Master of Puppets'
            }
          }
        ] 
      }.to_json)

    stub_request(:get, 'https://api.spotify.com/v1/me/albums?limit=50&offset=50')
      .to_return(body: { items: [] }.to_json)
  end

  context 'The liked albums endpoint' do
    context 'When an access token for the user is already present' do
      before do
        get "/liked_albums", params: { 'code' => 'an_authorisation_code' }
      end

      it 'does not attempt to request a new one' do
        get "/liked_albums"
        expect(WebMock).to have_requested(:post, "#{SPOTIFY_BASE_ENDPOINT}/api/token").once
      end
    end

    it 'returns the albums a user has saved' do
      get "/liked_albums", params: { 'code' => 'an_authorisation_code' }

      expect(JSON.parse(response.body)).to include('Metallica - Master of Puppets')
    end
  end
end