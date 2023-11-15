class Admin::RecipeCommentsController < ApplicationController
  before_action :check_admin_sign_in
  
  def index
    @recipe = Recipe.find(params[:recipe_id])
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
    @recipe_difficulty = @recipe.difficulty_judgment
  end
  
  def update
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_comment = @recipe.recipe_comments.find(params[:id])
    @recipe_difficulty = @recipe.difficulty_judgment
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
