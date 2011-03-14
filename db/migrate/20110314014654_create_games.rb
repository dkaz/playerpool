class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :url
      t.string :home
      t.string :away
      t.string :json_response

      t.timestamps
    end
  end

  def self.down
    drop_table :games
  end
end
