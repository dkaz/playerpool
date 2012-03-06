require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  def setup
    super
    @game = Game.create :url => 'http://rivals.yahoo.com'
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:games)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game" do
    assert_difference('Game.count') do
      post :create, :game => {:url => 'http://rivals.yahoo.com/2'}
    end

    assert_redirected_to game_path(assigns(:game))
  end

  test "should show game" do
    get :show, :id => @game.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @game.to_param
    assert_response :success
  end

  test "should update game" do
    put :update, :id => @game.to_param, :game => @game.attributes
    assert_redirected_to game_path(assigns(:game))
  end

end
