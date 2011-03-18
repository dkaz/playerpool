require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.create :first_name => 'Joe', :last_name => 'Shmoe'
  end

  test 'should calculate total points' do
    @user.players << Player.create(:first_name => 'Deron', :last_name => 'Williams', :points => 20, :team_id => teams(:one).to_param)
    assert_equal 20, @user.total_points
    @user.players << Player.create(:first_name => 'Dee', :last_name => 'Brown', :points => 15)
    assert_equal 35, @user.total_points
  end

  test 'should calculate players remaining' do
    @user.players << Player.create(:first_name => 'Deron', :last_name => 'Williams', :points => 20, :team_id => teams(:one).to_param)
    hoosiers = Team.create :code => 'INDIANA', :name => 'Indiana', :eliminated => true
    @user.players << Player.create(:first_name => 'Marco', :last_name => 'Killingsworth', :team_id => hoosiers.to_param)
    assert_equal 1, @user.players_remaining
  end
end
