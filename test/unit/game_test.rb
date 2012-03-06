require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'should fill in attributes' do
    game = Game.create! :url => 'http://rivals.yahoo.com'
    assert_not_nil game
    assert_equal 'kaf', game.away.code
    assert_equal 'fak', game.home.code
  end

  test 'should add points to player' do
    game = Game.create! :url => 'http://rivals.yahoo.com'
    assert_equal 12, Player.find_by_last_name('Teague').points
    assert_equal 21, Player.find_by_last_name('Young').points
  end

  test 'should create player if he does not exist' do
    game = Game.create! :url => 'http://rivals.yahoo.com'
    player = Player.find_by_last_name('Rosario')
    assert_not_nil player, 'Rosario was not created'
    assert_equal 4, player.points 
  end

  test 'should create team if it does not exist' do
    game = Game.create! :url => 'http://rivals.yahoo.com'
    team = Team.find_by_code('kaf')
    assert_not_nil team, 'Kentucky was not created'
    assert_equal 'Kentucky', team.name
  end

  test 'should eliminate losers' do
    game = Game.create! :url => 'http://rivals.yahoo.com'
    team = Team.find_by_code('fak')
    player = Player.find_by_last_name('Rosario')
    assert team.eliminated?, 'Rosario was not eliminated'
    assert player.eliminated?, 'Rosario was not eliminated'
  end

  test 'should subtract points when deleting game' do
    game = Game.create! :url => 'http://rivals.yahoo.com'
    game.destroy
    assert_equal 0, Player.find_by_last_name('Young').points
    assert_equal 0, Player.find_by_last_name('Teague').points
  end
end
