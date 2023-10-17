require "test_helper"

class Admin::RecipeStepsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_recipe_steps_index_url
    assert_response :success
  end
end
