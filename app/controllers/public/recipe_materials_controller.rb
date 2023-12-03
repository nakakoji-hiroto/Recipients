class Public::RecipeMaterialsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  
  def new
    @recipe = Recipe.find(params[:recipe_id])
    recipe_user = @recipe.user
    #レシピの投稿者以外のユーザーが材料登録ページを表示させようとした場合、レシピ詳細ページへ遷移させる
    identification_user(recipe_user, recipe_path(@recipe))
    @recipe_material = RecipeMaterial.new
    @recipe_materials = RecipeMaterial.all
    @recipe_genre = @recipe.genre.name
    @recipe_tags = @recipe.tags
    @recipe_difficulty = @recipe.difficulty_judgment
  end

  def index
    @recipe_materials = RecipeMaterial.all
  end
  
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_material = RecipeMaterial.new(recipe_material_params)
    @recipe_material.recipe_id = @recipe.id
    if @recipe_material.save
      redirect_to new_recipe_recipe_material_path(@recipe)
    else
      @recipe_materials = RecipeMaterial.all
      @recipe_genre = @recipe.genre.name
      @recipe_tags = @recipe.tags
      render 'new'
    end
  end
  
  def destroy
    recipe = Recipe.find(params[:recipe_id])
    recipe_material = RecipeMaterial.find(params[:id])
    if recipe.user != current_user
      redirect_to recipe_path(recipe)
    else
      recipe_material.destroy
      redirect_to new_recipe_recipe_material_path(recipe)
    end
  end
  
  private
  
  def recipe_material_params
    params.require(:recipe_material).permit(:name, :quantity)
  end
end
