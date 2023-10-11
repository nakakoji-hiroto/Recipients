require "test_helper"

class Public::RecipeMaterialsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_recipe_materials_new_url
    assert_response :success
  end

  test "should get index" do
    get public_recipe_materials_index_url
    assert_response :success
  end
end
