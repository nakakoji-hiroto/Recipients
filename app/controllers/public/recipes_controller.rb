class Public::RecipesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user ,except: [:index, :show, :genre_search]
  def new
    @recipe = Recipe.new
  end

  def index
    @recipe = Recipe.new
    indicate_recipes = Recipe.where(is_release: true)
    # 公開中のレシピのみページネーションして表示する
    @recipes = Kaminari.paginate_array(indicate_recipes).page(params[:page])
    @criteria_choice = {いいねが多い順に: 'favorite', 閲覧数が多い順に: 'many_views', 難易度が易しい順に: 'easy'}
    @display_choice = {　5件: 5,　10件: 10,　30件: 30,　50件: 50,　100件: 100}
    @new_recipes = Recipe.order('id DESC').limit(3)
    criteria = params[:criteria]
    display = params[:display]
    case criteria
      when 'favorite'
        #すべての投稿レシピから「公開」状態のものを抽出 >> 各レシピにつけられたいいね数の多い順に並び替え
        filtered_recipes = Recipe.where(is_release: true).includes(:favorites).sort_by { |recipe| -recipe.favorites.count }
        #抽出結果が格納された配列の先頭から、フォームから受け取った件数分のデータを抽出する。
        filtered_recipes_display = filtered_recipes.first(display.to_i)
        #Kaminariでページネーションして,viewページに渡す。
        @recipes = Kaminari.paginate_array(filtered_recipes_display).page(params[:page])
        flash.now[:filter_result] = "いいねが多い順に#{display}件、表示しました。"
        @filtered = true
      when 'many_views'
        @filtered_recipes = @recipe.recipe_comments.order('id DESC')
      when 'easy'
        @filtered_recipes = @recipe.recipe_comments.order('id ASC')
      else
        @recipes = Kaminari.paginate_array(indicate_recipes).page(params[:page])
        @filtered = false
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
    unless @recipe.is_release
      redirect_to recipes_path
    end
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
      @tag_list = @recipe.tags.pluck(:name).join(',')
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
    #非公開になっているレシピの件数をカウントする
    @recipe_count = @genre_recipes.where(is_release: true).count
  end
  
  private
  
  def recipe_params
    params.require(:recipe).permit(:title, :catch_copy, :genre_id, :image)
  end
end
