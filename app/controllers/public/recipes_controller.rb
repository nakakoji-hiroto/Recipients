class Public::RecipesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user ,except: [:index, :show]
  def new
    @recipe = Recipe.new
  end

  def index
    @recipe = Recipe.new
    @new_recipes = Recipe.order('id DESC').limit(3)
  end

  def show
    @recipe = Recipe.find(params[:id])
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    if @recipe.save
      flash[:notice] = "新規レシピを投稿しました。"
      redirect_to recipe_path(@recipe)
    else
      render 'new'
    end
  end
  
  def edit
    @recipe = Recipe.find(params[:id])
  end
  
  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      flash[:notice] = "レシピを更新しました。"
      redirect_to recipe_path(@recipe)
    else
      render 'edit'
    end
  end
  
  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
    flash[:notice] = "レシピを削除しました。"
    redirect_to recipes_path
  end
  
  def genre_search
    @genre_recipes = Recipe.where(genre_id: recipe_params[:genre_id])
    @genre = Genre.find(recipe_params[:genre_id])
  end
  
  private
  
  def recipe_params
    params.require(:recipe).permit(:title, :catch_copy, :genre_id, :image)
  end
end
