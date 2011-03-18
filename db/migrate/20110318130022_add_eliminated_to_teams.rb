class AddEliminatedToTeams < ActiveRecord::Migration
  def self.up
    add_column :teams, :eliminated, :boolean, :default => false
  end

  def self.down
    remove_column :teams, :eliminated
  end
end
