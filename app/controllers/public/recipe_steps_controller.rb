class Public::RecipeStepsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user, except: [:index]

  def new
    @recipe = Recipe.find(params[:recipe_id])
    recipe_user = @recipe.user
    #レシピの投稿者以外のユーザーが材料登録ページを表示させようとした場合、レシピ詳細ページへ遷移させる
    identification_user(recipe_user, recipe_path(@recipe))
    @recipe_step = RecipeStep.new
    @recipe_steps = @recipe.recipe_steps.page(params[:page]).order('step ASC')
    @delete_button = true
  end

  def index
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_steps = @recipe.recipe_steps.page(params[:page]).order('step ASC').per(10)
    @delete_button = false
  end

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_step = RecipeStep.new(recipe_step_params)
    if @recipe.recipe_steps.find_by(step: @recipe_step.step)
      flash[:notice] = "手順番号が重複しています。"
      redirect_to  new_recipe_recipe_step_path(@recipe)
      return
    end
    @recipe_step.recipe_id = @recipe.id
    if @recipe_step.save
      flash[:notice] = "手順を登録しました"
      redirect_to new_recipe_recipe_step_path(@recipe)
    else
      @recipe_steps = @recipe.recipe_steps.page(params[:page]).order('step ASC')
      @delete_button = true
      render 'new'
    end
  end

  def destroy
    recipe = Recipe.find(params[:recipe_id])
    recipe_step = RecipeStep.find(params[:id])
    recipe_step.destroy
    flash[:notice] = "手順を削除しました"
    redirect_to new_recipe_recipe_step_path(recipe)
  end

  private

  def recipe_step_params
    params.require(:recipe_step).permit(:step, :explanation, :image)
  end

end
