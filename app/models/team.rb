class Team < ActiveRecord::Base
  has_many :players

  validates_uniqueness_of :code

  def to_s
    self.name
  end
end
