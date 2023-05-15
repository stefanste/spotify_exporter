require 'rails_helper'

RSpec.describe "Retrieving a user's liked albums", type: :request do
  before do
    stub_request(:post, "#{SPOTIFY_BASE_ENDPOINT}/api/token")
      .with(headers: { 'Authorization' => 'Basic MDEyMzQ1Njc4OWFiY2RlZjowMTIzNDU2Nzg5YWJjZGVm' })
      .to_return(body: { 'access_token' => 'abc', 'refresh_token' => 'def' }.to_json)
    
    stub_request(:get, 'https://api.spotify.com/v1/me/')
      .with(headers: { 'Authorization'=>'Bearer abc' })
      .to_return(body: {
        'display_name' => 'Blobby Bronzebeard',
        'id' => 'blobby_bronzebeard',
        'type' => 'user',
        'uri' => 'spotify:user:blobby_bronzebeard',
        'followers' => {},
        'external_urls' => {}
      }.to_json)

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
    context 'when the authorisation code is submitted' do
      let(:params) { { 'code' => 'an_authorisation_code' } }

      it 'exchanges the code for the access & refresh token, and persists them for the user' do
        get "/liked_albums", params: params
        
        user = User.find_by(spotify_id: 'blobby_bronzebeard')

        expect(user).to be_present
        expect(user.access_token).to eq 'abc'
        expect(user.refresh_token).to eq 'def'
      end

      it 'redirects to the requested action with the relevant user ID' do
        get "/liked_albums", params: params

        expect(response).to redirect_to(action: 'liked_albums', user_id: 'blobby_bronzebeard')
      end
    end

    context 'when a user ID is submitted' do
      let(:params) { { 'user_id' => 'blobby_bronzebeard' } }

      before { get "/liked_albums", params: { 'code' => 'an_authorisation_code' } }

      it 'returns the albums a user has saved' do
        get "/liked_albums", params: params

        expect(JSON.parse(response.body)).to include('Metallica - Master of Puppets')
      end

      it 'does not attempt to fetch new access/refresh tokens' do
        get "/liked_albums", params: params
        
        expect(WebMock).to have_requested(:post, "#{SPOTIFY_BASE_ENDPOINT}/api/token").once
      end
    end

    context 'when the request to Spotify to fetch liked albums fails' do
      before do
        stub_request(:post, "#{SPOTIFY_BASE_ENDPOINT}/api/token")
          .to_return(status: 500, body: "error", headers: {})
      end

      let(:params) { { 'code' => 'an_authorisation_code' } }

      it 'returns an error response' do
        get "/liked_albums", params: params

        expect(JSON.parse(response.body)).to include('error' => 'An error response was received from an external upstream system: Spotify::ApiError: Response status: 500, response body: error')
        expect(response.status).to eq 502
      end
    end
  end
end