ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha'

class Test::Unit::TestCase
  def setup
    response = mock
    response.stubs('body').returns(File.read(File.expand_path('../data/game.html', __FILE__)))
    response.stubs('code').returns('200')
    Net::HTTP.stubs('get_response').returns(response) 
  end
end

