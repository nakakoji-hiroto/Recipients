class Admin::RecipeStepsController < ApplicationController
  before_action :check_admin_sign_in
  
  def index
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_steps = @recipe.recipe_steps.page(params[:page]).order('step ASC')
  end
end
