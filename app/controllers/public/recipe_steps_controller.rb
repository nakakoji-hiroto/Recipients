class Public::RecipeStepsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user

  def new
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_step = RecipeStep.new
    @recipe_steps = @recipe.recipe_steps.order('step ASC')
    @delete_button = true
  end

  def index
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_steps = @recipe.recipe_steps.order('step ASC')
    @delete_button = false
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_step = RecipeStep.new(recipe_step_params)
    if @recipe.recipe_steps.find_by(step: @recipe_step.step)
      flash.now[:notice] = "手順番号が重複しています。"
      @recipe_steps = @recipe.recipe_steps.order('step ASC')
      render 'new'
      return
    end
    @recipe_step.recipe_id = @recipe.id
    if @recipe_step.save
      redirect_to new_recipe_recipe_step_path(@recipe)
    else
      @recipe_steps = @recipe.recipe_steps.order('step ASC')
      render 'new'
    end
  end

  def destroy
    recipe = Recipe.find(params[:recipe_id])
    recipe_step = RecipeStep.find(params[:id])
    recipe_step.destroy
    redirect_to new_recipe_recipe_step_path(recipe)
  end

  private

  def recipe_step_params
    params.require(:recipe_step).permit(:step, :explanation, :image)
  end

end
