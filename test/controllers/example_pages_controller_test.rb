require 'test_helper'

class ExamplePagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get example_pages_home_url
    assert_response :success
  end

  test "should get help" do
    get example_pages_help_url
    assert_response :success
  end

  test "should get about" do
    get example_pages_about_url
    assert_response :success
  end

end
