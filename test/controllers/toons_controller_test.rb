require 'test_helper'

class ToonsControllerTest < ActionController::TestCase
  setup do
    @toon = toons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:toons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create toon" do
    assert_difference('Toon.count') do
      post :create, toon: { name: @toon.name }
    end

    assert_redirected_to toon_path(assigns(:toon))
  end

  test "should show toon" do
    get :show, id: @toon
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @toon
    assert_response :success
  end

  test "should update toon" do
    patch :update, id: @toon, toon: { name: @toon.name }
    assert_redirected_to toon_path(assigns(:toon))
  end

  test "should destroy toon" do
    assert_difference('Toon.count', -1) do
      delete :destroy, id: @toon
    end

    assert_redirected_to toons_path
  end
end
