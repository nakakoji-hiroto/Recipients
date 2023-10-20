class Admin::RecipesController < ApplicationController
  before_action :check_admin_sign_in
  
  def index
    @recipe = Recipe.new
    @recipes = Recipe.page(params[:page]).per(10)
    @word_search_criteria_choice = {レシピ名: 'title', キャッチコピー: 'catch_copy'}
  end

  def show
    @recipe = Recipe.find(params[:id])
    @recipe_tags = @recipe.tags
  end
  
  def update
    @recipe = Recipe.find(params[:id])
    @recipe_tags = @recipe.tags
    if @recipe.is_release
      @recipe.is_release = false
      @recipe.save
      flash.now[:is_release_changed] = '※レシピを非公開に設定しました'
    else
      @recipe.is_release = true
      @recipe.save
      flash.now[:is_release_changed] = '※レシピを公開に設定しました'
    end
  end
  
  def genre_search
    genre_recipes = Recipe.where(genre_id: params[:recipe][:genre_id])
    @genre = Genre.find(params[:recipe][:genre_id])
    @genre_recipes = Kaminari.paginate_array(genre_recipes).page(params[:page]).per(10)
  end
  
  def word_search
    @word_search_criteria = params[:word_search_criteria]
    @word = params[:word]
    if @word_search_criteria == 'title'
      word_search_recipes = Recipe.where("title LIKE?","%#{@word}%")
      @recipe_count = word_search_recipes.count
      @word_search_recipes = Kaminari.paginate_array(word_search_recipes).page(params[:page]).per(10)
    elsif @word_search_criteria == 'catch_copy'
      word_search_recipes = Recipe.where("catch_copy LIKE?","%#{@word}%")
      @recipe_count = word_search_recipes.count
      @word_search_recipes = Kaminari.paginate_array(word_search_recipes).page(params[:page]).per(10)
    else
      redirect_to recipes_path
    end
  end
  
end
