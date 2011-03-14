class Player < ActiveRecord::Base
  belongs_to :team

  validates_uniqueness_of :last_name, :scope => [:first_name, :team_id]
end
