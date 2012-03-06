require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = User.create :first_name => 'Joe', :last_name => 'Schmoe'
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => @user.attributes
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, :id => @user.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user.to_param
    assert_response :success
  end

  test "should update user" do
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user.to_param
    end

    assert_redirected_to users_path
  end

  test "should add player to user" do
    player = Player.create :yahoo_id => 123
    assert_difference('@user.players.count') do
      post :add_player, :id => @user.to_param, :player_id => player
    end

    assert_redirected_to edit_user_path(@user)
  end
end
