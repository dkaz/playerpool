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
end
