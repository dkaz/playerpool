class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name

      t.timestamps
    end

    create_table :players_users, :id => false do |t|
      t.references :user
      t.references :player
    end
  end

  def self.down
    drop_table :users
    drop_table :players_users
  end
end
