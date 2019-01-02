require 'test_helper'

class BaseInfoControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get base_info_show_url
    assert_response :success
  end

  test "should get index" do
    get base_info_index_url
    assert_response :success
  end

  test "should get new" do
    get base_info_new_url
    assert_response :success
  end

  test "should get edit" do
    get base_info_edit_url
    assert_response :success
  end

  test "should get create" do
    get base_info_create_url
    assert_response :success
  end

end
