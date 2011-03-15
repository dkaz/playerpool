class Player < ActiveRecord::Base
  belongs_to :team
  has_and_belongs_to_many :users

  validates_uniqueness_of :last_name, :scope => [:first_name, :team_id]

  def self.find_or_create last_name, first_name, team
    params = {:last_name => last_name, :first_name => first_name, :team_id => team.id}
    player = Player.where(params).first
    player = Player.create! params if player.nil?
    player
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
