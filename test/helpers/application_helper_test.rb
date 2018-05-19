require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "RUN CLUB"
    assert_equal full_title("Help"), "Help | RUN CLUB"
  end
end