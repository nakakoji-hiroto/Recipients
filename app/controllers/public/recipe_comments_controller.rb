class Public::RecipeCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user,except: [:index, :show]
  
  def new
    @recipe_comment = RecipeComment.new
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_tags = @recipe.tags
  end
  
  def create
    @recipe_comment = current_user.recipe_comments.new(recipe_comment_params)
    @recipe_comment.recipe_id = params[:recipe_id]
    if @recipe_comment.save
      flash[:notice] = "新規レビューを投稿しました"
      redirect_to recipe_recipe_comment_path(@recipe_comment.recipe, @recipe_comment)
    else
      @recipe = Recipe.find(params[:recipe_id])
      @recipe_tags = @recipe.tags
      render 'new'
    end
  end
  
  def index
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_comments = RecipeComment.all
  end
  
  def show
    @recipe_comment = RecipeComment.find(params[:id])
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_tags = @recipe.tags
  end
  
  def destroy
    recipe_comment = RecipeComment.find(params[:id])
    recipe_comment.delete
    flash[:notice] = "レビューを削除しました"
    redirect_to recipe_path(params[:recipe_id])
  end
  
  private
  
  def recipe_comment_params
    params.require(:recipe_comment).permit(:comment, :score, :is_release)
  end
end
