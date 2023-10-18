class Admin::RecipesController < ApplicationController
  before_action :check_admin_sign_in
  
  def index
    @recipe = Recipe.new
    @recipes = Recipe.page(params[:page]).per(10)
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
    @genre_recipes = Recipe.where(genre_id: params[:recipe][:genre_id])
    @genre = Genre.find(params[:recipe][:genre_id])
  end
  
end
