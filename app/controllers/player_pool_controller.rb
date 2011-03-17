class PlayerPoolController < ApplicationController
  def index
    @users = User.all.sort_by{|u| u.total_points}.reverse
  end
end
