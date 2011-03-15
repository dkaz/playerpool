require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should calculate total points" do
    u = User.create :first_name => 'Joe', :last_name => 'Shmoe'
    u.players << Player.create(:first_name => 'Deron', :last_name => 'Williams', :points => 20)
    assert_equal 20, u.total_points
    u.players << Player.create(:first_name => 'Dee', :last_name => 'Brown', :points => 15)
    assert_equal 35, u.total_points
  end
end
