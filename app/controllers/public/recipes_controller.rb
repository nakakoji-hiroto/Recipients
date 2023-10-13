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
    @recipe_tags = @recipe.tags
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = current_user.id
    tag_list=params[:recipe][:tag_name].split(/,|\.|、|・/)
    if @recipe.save
      #新しくつけられたタグを追加保存する
      @recipe.save_tag(tag_list)
      flash[:notice] = "新規レシピを投稿しました。"
      redirect_to recipe_path(@recipe)
    else
      render 'new'
    end
  end
  
  def edit
    @recipe = Recipe.find(params[:id])
    @tag_list = @recipe.tags.pluck(:name).join(',')
  end
  
  def update
    @recipe = Recipe.find(params[:id])
    tag_list=params[:recipe][:tag_name].split(/,|\.|、|・/)
    if @recipe.update(recipe_params)
      #@old_relations = RecipeTag.where(recipe_id: @recipe.id)
      #@old_relations.each do |relation|
        #relation.delete
      #end
      @recipe.save_tag(tag_list)
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
