class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.references :team
      t.string :first_name
      t.string :last_name
      t.integer :points, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
