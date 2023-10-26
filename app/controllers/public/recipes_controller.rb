class Public::RecipesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user ,except: [:index, :show, :genre_search]
  def new
    @recipe = Recipe.new
    @difficulty_choice = {易しい: "1", やや易しい: "2", 普通: "3", やや難しい: "4", 難しい: "5"}
  end

  def index
    @recipe = Recipe.new
    indicate_recipes = Recipe.where(is_release: true)
    # 公開中のレシピのみページネーションして表示する
    @recipes = Kaminari.paginate_array(indicate_recipes).page(params[:page])
    @criteria_choice = {いいねが多い順に: 'favorite', 閲覧数が多い順に: 'many_views', 難易度が易しい順に: 'easy'}
    @display_choice = {　5件: 5,　10件: 10,　30件: 30,　50件: 50,　100件: 100}
    @word_search_criteria_choice = {レシピ名: 'title', キャッチコピー: 'catch_copy'}
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
        #すべての投稿レシピから「公開」状態のものを抽出 >> 各レシピごとの閲覧数の多い順に並び替え
        filtered_recipes = Recipe.where(is_release: true).includes(:view_counts).sort_by { |recipe| -recipe.view_counts.count }
        #抽出結果が格納された配列の先頭から、フォームから受け取った件数分のデータを抽出する。
        filtered_recipes_display = filtered_recipes.first(display.to_i)
        #Kaminariでページネーションして,viewページに渡す。
        @recipes = Kaminari.paginate_array(filtered_recipes_display).page(params[:page])
        flash.now[:filter_result] = "閲覧数が多い順に#{display}件、表示しました。"
        @filtered = true
      when 'easy'
        #すべての投稿レシピから「公開」状態のものを抽出 >> 各レシピにつけられた難易度の易しい順に並び替え
        #フォームから受け取った件数分のデータを抽出する。
        filtered_recipes = Recipe.where(is_release: true).order('difficulty ASC').limit(display)
        #Kaminariでページネーションして,viewページに渡す。
        @recipes = Kaminari.paginate_array(filtered_recipes).page(params[:page])
        flash.now[:filter_result] = "難易度が易しい順に#{display}件、表示しました。"
        @filtered = true
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
    #投稿閲覧数のカウント　-- 自分が投稿したレシピを自分自身で閲覧しても閲覧数としてカウントしない。
    unless ViewCount.find_by(user_id: current_user.id, recipe_id: @recipe.id)
      unless @recipe.user == current_user
        current_user.view_counts.create(recipe_id: @recipe.id)
      end
    end
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
      @difficulty_choice = {易しい: "1", やや易しい: "2", 普通: "3", やや難しい: "4", 難しい: "5"}
      render 'new'
    end
  end
  
  def edit
    @recipe = Recipe.find(params[:id])
    @tag_list = @recipe.tags.pluck(:name).join(',')
    @difficulty_choice = {易しい: "1", やや易しい: "2", 普通: "3", やや難しい: "4", 難しい: "5"}
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
      @difficulty_choice = {易しい: "1", やや易しい: "2", 普通: "3", やや難しい: "4", 難しい: "5"}
      render 'edit'
    end
  end
  
  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
    flash[:notice] = "レシピを削除しました。"
    redirect_to user_path(current_user)
  end
  
  def genre_search
    genre_recipes = Recipe.where(genre_id: recipe_params[:genre_id]).where(is_release: true)
    @genre = Genre.find(recipe_params[:genre_id])
    #非公開になっているレシピの件数をカウントする
    @recipe_count = genre_recipes.where(is_release: true).count
    @genre_recipes = Kaminari.paginate_array(genre_recipes).page(params[:page]).per(10)
  end
  
  def word_search
    @word_search_criteria = params[:word_search_criteria]
    @word = params[:word]
    if @word_search_criteria == 'title'
      word_search_recipes = Recipe.where("title LIKE?","%#{@word}%").where(is_release: true)
      #非公開になっているレシピの件数をカウントする
      @recipe_count = word_search_recipes.where(is_release: true).count
      @word_search_recipes = Kaminari.paginate_array(word_search_recipes).page(params[:page]).per(10)
    elsif @word_search_criteria == 'catch_copy'
      word_search_recipes = Recipe.where("catch_copy LIKE?","%#{@word}%").where(is_release: true)
      #非公開になっているレシピの件数をカウントする
      @recipe_count = word_search_recipes.where(is_release: true).count
      @word_search_recipes = Kaminari.paginate_array(word_search_recipes).page(params[:page]).per(10)
    else
      redirect_to recipes_path
    end
  end
  
  private
  
  def recipe_params
    params.require(:recipe).permit(:title, :catch_copy, :genre_id, :image, :difficulty)
  end
end
