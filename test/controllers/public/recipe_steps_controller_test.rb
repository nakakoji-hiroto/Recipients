require "test_helper"

class Public::RecipeStepsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_recipe_steps_new_url
    assert_response :success
  end

  test "should get index" do
    get public_recipe_steps_index_url
    assert_response :success
  end
end
