class Public::TagsController < ApplicationController
  before_action :authenticate_user!
  #before_action :ensure_guest_user

  def tag_search
    @tag = Tag.find_by(name: params[:name])
    @private_recipe_count = 0
    if @tag.present?
      @tag_recipes = @tag.recipes
      @tag_search = true
    #非公開になっているレシピの件数をカウントする
    @recipe_count = @tag_recipes.where(is_release: true).count
    #   @tag_recipes.each do |tag_recipe|
    #     unless tag_recipe.is_release
    #       @private_recipe_count += 1
    #     end
    #   end
    # @recipe_count = @tag_recipes.count - @private_recipe_count
    elsif params[:name].blank?
      flash[:alert] = "※タグ名が入力されていません"
      redirect_to request.referer
    else
      @tag = params[:name]
      @tag_recipes = 0
      @tag_search = false
    end
  end
end
