class PlayerPoolController < ApplicationController
  def index
    @users = User.all
  end
end
