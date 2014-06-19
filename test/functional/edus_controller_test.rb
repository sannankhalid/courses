require 'test_helper'

class EdusControllerTest < ActionController::TestCase
  setup do
    @edu = edus(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:edus)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create edu" do
    assert_difference('Edu.count') do
      post :create, edu: { current_education_level: @edu.current_education_level, resume: @edu.resume }
    end

    assert_redirected_to edu_path(assigns(:edu))
  end

  test "should show edu" do
    get :show, id: @edu
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @edu
    assert_response :success
  end

  test "should update edu" do
    put :update, id: @edu, edu: { current_education_level: @edu.current_education_level, resume: @edu.resume }
    assert_redirected_to edu_path(assigns(:edu))
  end

  test "should destroy edu" do
    assert_difference('Edu.count', -1) do
      delete :destroy, id: @edu
    end

    assert_redirected_to edus_path
  end
end
