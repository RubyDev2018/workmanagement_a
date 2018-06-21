require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "WORK MANAGEMENT"
    assert_equal full_title("Help"), "Help | WORK MANAGEMENT"
  end
end