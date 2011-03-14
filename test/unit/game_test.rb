require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test 'should fill in attributes' do
    game = Game.create! :url => 'http://api.fanfeedr.com'
    assert_not_nil game
    assert_equal 'PENNST', game.away
    assert_equal 'OHIOST', game.home
  end

  test 'should add points to player' do
    game = Game.create! :url => 'http://api.fanfeedr.com'
    assert_equal 45, Player.find_by_last_name('Sullinger').points
  end

  test 'should create player if he does not exist' do
    game = Game.create! :url => 'http://api.fanfeedr.com'
    player = Player.find_by_last_name('Lighty')
    assert_not_nil player, 'Lighty was not created'
    assert_equal 8, player.points 
  end
end
