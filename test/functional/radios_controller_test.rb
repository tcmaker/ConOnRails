require 'test_helper'

class RadiosControllerTest < ActionController::TestCase
  setup do
    @assignment = FactoryGirl.build :valid_radio_assignment
    @radio = FactoryGirl.build :valid_blue_radio
    @user  = FactoryGirl.create :user
    @role  = FactoryGirl.create :admin_radios_role
    @user.roles << @role
    @user_session = { user_id: @user.id }
    @volunteer = FactoryGirl.create :valid_volunteer
  end

  test "should get index" do
    get :index, { }, @user_session
    assert_response :success
    assert_not_nil assigns(:radios)
   end

  test "should get new" do
    get :new, { }, @user_session
    assert_response :success
  end

  test "should create radio" do
    assert_difference('Radio.count') do
      post :create, { radio: @radio.attributes }, @user_session
    end

    assert_redirected_to radio_path(assigns(:radio))
  end

  test "should show radio" do
    @radio.save!
    get :show, { id: @radio.to_param }, @user_session
    assert_response :success
  end

  test "should get edit" do
    @radio.save!
    get :edit, { id: @radio.to_param }, @user_session
    assert_response :success
  end

  test "should update radio" do
    @radio.save!
    put :update, { id: @radio.to_param, radio: @radio.attributes }, @user_session
    assert_redirected_to radio_path(assigns(:radio))
  end

  test "should destroy radio" do
    @radio.save!
    assert_difference('Radio.count', -1) do
      delete :destroy, { id: @radio.to_param }, @user_session
    end

    assert_redirected_to radios_path
  end

  test "should get checkout form" do
    @radio.save!
    get :checkout, { id: @radio.to_param }, @user_session
    assert_response :success
  end

  test "should checkout a radio" do
    @radio.save!
    @radio.state = "out"

    assert_difference 'RadioAssignment.count' do
      put :update, { id: @radio.to_param, radio: @radio.attributes, radio_assignment: @assignment.attributes }, @user_session
    end
    assert_redirected_to radio_path(assigns :radio)
  end

  test "should get checkin form" do
    @radio.radio_assignment = RadioAssignment.new @assignment.attributes
    @radio.save!

    get :checkin, { id: @radio.to_param }, @user_session
    assert_response :success
  end

  test "can search volunteers" do
    @radio.save!
    post :search_volunteers, { first_name: @volunteer.first_name, last_name: @volunteer.last_name, radio: @radio.to_param }, @user_session
    assert_response :success
  end

  test "can select department" do
    @radio.save!
    get :select_department, { id: @radio.to_param, volunteer: @volunteer.to_param }, @user_session
    assert_response :success
    assert_not_nil assigns :department
  end
end