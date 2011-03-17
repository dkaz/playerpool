class RemoveJsonResponseFromGames < ActiveRecord::Migration
  def self.up
    remove_column :games, :json_response
  end

  def self.down
    add_column :games, :json_response, :string
  end
end
