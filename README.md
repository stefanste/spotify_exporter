# spotify_exporter
Export and backup your Spotify playlists and saved music.

## Usage
To run the application locally:
- Copy .env dev/test files and update app client ID & secret
- Run migrations - `bin/rails db:migrate`
- Run server - `bin/rails server`
- Visit `localhost:3000/<liked_albums|liked_tracks>` and grant the app access to your Spotify account 

## Todo

- Implement using refresh token to get new access token when needed