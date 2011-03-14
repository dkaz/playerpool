require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "should find or create player" do
    player = Player.create! :first_name => 'Dee', :last_name => 'Brown', :team => teams(:one)
    found = Player.find_or_create 'Brown', 'Dee', teams(:one)
    created = Player.find_or_create 'Williams', 'Deron', teams(:one)
    assert_equal found, player
    assert_not_nil created, "Created player not returned"
    assert_equal 4, Player.count
  end
end
