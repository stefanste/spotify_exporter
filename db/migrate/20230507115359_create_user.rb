class CreateUser < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :spotify_id, null: false, index: { unique: true }
      t.string :spotify_display_name, null: false
      t.string :access_token, null: false
      t.string :refresh_token, null: false

      t.timestamps
    end
  end
end
