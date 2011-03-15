class User < ActiveRecord::Base
  has_and_belongs_to_many :players

  def total_points
    players.inject(0){|points, player| points + player.points}
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
