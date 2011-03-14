class PlayerPoolController < ApplicationController
  def index
    @params = params
    @player = Player.find_by_last_name(@params['last_name'])
  end
end
