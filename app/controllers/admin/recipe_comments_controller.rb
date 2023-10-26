class Admin::RecipeCommentsController < ApplicationController
  before_action :check_admin_sign_in
  
  def index
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_comment = RecipeComment.new
    @choices = {評価の高い順に: 'high_rating', 日付の新しい順に: 'new', 日付の古い順に: 'old'}
    sort = params[:sort]
    case sort
      when 'high_rating'
        @recipe_comments = @recipe.recipe_comments.order('score DESC').page(params[:page]).per(9)
      when 'new'
        @recipe_comments = @recipe.recipe_comments.order('id DESC').page(params[:page]).per(9)
        @choices = {日付の新しい順に: 'new', 日付の古い順に: 'old', 評価の高い順に: 'high_rating'}
      when 'old'
        @recipe_comments = @recipe.recipe_comments.order('id ASC').page(params[:page]).per(9)
        @choices = {日付の古い順に: 'old',  評価の高い順に: 'high_rating', 日付の新しい順に: 'new'} 
      else
        @recipe_comments = @recipe.recipe_comments.page(params[:page]).per(9)
    end
  end

  def show
    @recipe_comment = RecipeComment.find(params[:id])
    @recipe = Recipe.find(params[:recipe_id])
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
  
  def update
    @recipe = Recipe.find(params[:recipe_id])
    #@recipe_tags = @recipe.tags
    @recipe_comment = @recipe.recipe_comments.find(params[:id])
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
    if @recipe_comment.is_release
      @recipe_comment.is_release = false
      @recipe_comment.save
      flash[:review_is_release_changed] = '※レビューを非公開に設定しました'
      redirect_to admin_recipe_recipe_comment_path(@recipe, @recipe_comment)
    else
      @recipe_comment.is_release = true
      @recipe_comment.save
      flash[:review_is_release_changed] = '※レビューを公開に設定しました'
      redirect_to admin_recipe_recipe_comment_path(@recipe, @recipe_comment)
    end
  end
  
end
