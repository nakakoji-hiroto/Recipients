class Public::TagsController < ApplicationController
  before_action :authenticate_user!

  def tag_search
    @tag = Tag.find_by(name: params[:name])
    @recipe_count = 0
    if @tag.present?
      tag_recipes = @tag.recipes.where(is_release: true)
      @tag_search = true
    #非公開になっているレシピの件数をカウントする
    @recipe_count = tag_recipes.where(is_release: true).count
    @tag_recipes = Kaminari.paginate_array(tag_recipes).page(params[:page])
    elsif params[:name].blank?
      flash[:alert] = "※タグ名が入力されていません"
      redirect_to request.referer
    else
      @tag = params[:name]
      @tag_search = false
    end
  end
end
