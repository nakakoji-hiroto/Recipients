class Public::RecipeCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user,except: [:index, :show]

  def new
    @recipe_comment = RecipeComment.new
    @recipe = Recipe.find(params[:recipe_id])
    unless @recipe.is_release
      redirect_to recipes_path
    end
    if @recipe.user == current_user
      redirect_to recipe_path(@recipe)
    end
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
    unless @recipe.is_release
      redirect_to recipes_path
    end
    @recipe_comment = RecipeComment.new
    @recipe_comments = @recipe.recipe_comments
    @private_recipe_comment_count = 0
    @choices = {評価の高い順に: 'high_rating', 日付の新しい順に: 'new', 日付の古い順に: 'old'}
    sort = params[:sort]
    #非公開になっているレビューの件数をカウントする
    @recipe_comments.each do |recipe_comment|
      unless recipe_comment.is_release
        @private_recipe_comment_count += 1
      end
    end
    @review_count = @recipe_comments.count - @private_recipe_comment_count
    
    case sort
      when 'high_rating'
        @recipe_comments = @recipe.recipe_comments.order('score DESC')
      when 'new'
        @recipe_comments = @recipe.recipe_comments.order('id DESC')
        @choices = {日付の新しい順に: 'new', 日付の古い順に: 'old', 評価の高い順に: 'high_rating'}
      when 'old'
        @recipe_comments = @recipe.recipe_comments.order('id ASC')
        @choices = {日付の古い順に: 'old',  評価の高い順に: 'high_rating', 日付の新しい順に: 'new'} 
      else
        @recipe_comments = @recipe.recipe_comments
    end
  end

  def show
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_comment = RecipeComment.find(params[:id])
    unless @recipe.is_release
      redirect_to recipes_path
    end
    unless @recipe_comment.is_release
      redirect_to recipe_recipe_comments_path(@recipe)
    end
    @recipe_tags = @recipe.tags
    case @recipe.difficulty
      when "1"
        @recipe_difficulty = "易しい"
      when "2"
        @recipe_difficulty = "やや易しい"
      when "3"
        @recipe_difficulty = "普通"
      when "4"
        @recipe_difficulty = "やや難しい"
      when "5"
        @recipe_difficulty = "難しい"
      else
        @recipe_difficulty = "未設定"
    end
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
