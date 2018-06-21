require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  test "should get home" do
    get root_path
    assert_response :success
    assert_select "title", "WORK MANAGEMENT"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | WORK MANAGEMENT"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | WORK MANAGEMENT"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | WORK MANAGEMENT"
  end
end