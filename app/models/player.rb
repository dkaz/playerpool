class Player < ActiveRecord::Base
  belongs_to :team
  has_and_belongs_to_many :users

  validates_uniqueness_of :last_name, :scope => [:first_name, :team_id]

  def full_name
    "#{first_name} #{last_name}"
  end

  def eliminated?
    team.eliminated
  end
end
