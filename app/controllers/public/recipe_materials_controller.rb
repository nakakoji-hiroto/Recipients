class Public::RecipeMaterialsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  
  def new
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_material = RecipeMaterial.new
    @recipe_materials = RecipeMaterial.all
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
      render 'new'
    end
  end
  
  def destroy
    recipe = Recipe.find(params[:recipe_id])
    recipe_material = RecipeMaterial.find(params[:id])
    recipe_material.destroy
    redirect_to new_recipe_recipe_material_path(recipe)
  end
  
  private
  
  def recipe_material_params
    params.require(:recipe_material).permit(:name, :quantity)
  end
end
