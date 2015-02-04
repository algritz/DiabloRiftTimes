require 'test_helper'

class TargetTimesControllerTest < ActionController::TestCase
  setup do
    @target_time = target_times(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:target_times)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create target_time" do
    assert_difference('TargetTime.count') do
      post :create, target_time: { difficulty_id: @target_time.difficulty_id, player_count: @target_time.player_count, target_time: @target_time.target_time }
    end

    assert_redirected_to target_time_path(assigns(:target_time))
  end

  test "should show target_time" do
    get :show, id: @target_time
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @target_time
    assert_response :success
  end

  test "should update target_time" do
    patch :update, id: @target_time, target_time: { difficulty_id: @target_time.difficulty_id, player_count: @target_time.player_count, target_time: @target_time.target_time }
    assert_redirected_to target_time_path(assigns(:target_time))
  end

  test "should destroy target_time" do
    assert_difference('TargetTime.count', -1) do
      delete :destroy, id: @target_time
    end

    assert_redirected_to target_times_path
  end
end
