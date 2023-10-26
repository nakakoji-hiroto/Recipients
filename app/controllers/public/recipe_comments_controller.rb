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
      return
    end
    recipe_comments = @recipe.recipe_comments
    #レシピにつけられたレビュー全件より、公開中のレシピのみ抽出する
    indicate_recipe_comments = recipe_comments.where(is_release: true)
    #公開中のレビューの総件数を数える
    @review_count = indicate_recipe_comments.count
    @choices = {評価の高い順に: 'high_rating', 日付の新しい順に: 'new', 日付の古い順に: 'old'}
    sort = params[:sort]
    
    case sort
      when 'high_rating'
        #公開中のレビューをスコアの高い順に並べ替える
        recipe_comments = @recipe.recipe_comments.where(is_release: true).order('score DESC')
        #Kaminariでページネーションして,viewページに渡す。
        @recipe_comments = Kaminari.paginate_array(recipe_comments).page(params[:page]).per(9)
      when 'new'
        #公開中のレビューを投稿日付の新しい順に並べ替える
        recipe_comments = @recipe.recipe_comments.where(is_release: true).order('id DESC')
        #Kaminariでページネーションして,viewページに渡す。
        @recipe_comments = Kaminari.paginate_array(recipe_comments).page(params[:page]).per(9)
        @choices = {日付の新しい順に: 'new', 日付の古い順に: 'old', 評価の高い順に: 'high_rating'}
      when 'old'
        #公開中のレビューを投稿日付の古い順に並べ替える
        recipe_comments = @recipe.recipe_comments.where(is_release: true).order('id ASC')
        #Kaminariでページネーションして,viewページに渡す。
        @recipe_comments = Kaminari.paginate_array(recipe_comments).page(params[:page]).per(9)
        @choices = {日付の古い順に: 'old',  評価の高い順に: 'high_rating', 日付の新しい順に: 'new'} 
      else
        @recipe_comments = Kaminari.paginate_array(indicate_recipe_comments).page(params[:page]).per(9)
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
