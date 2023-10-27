class Admin::TagsController < ApplicationController
  before_action :check_admin_sign_in
  
  def tag_search
    @tag = Tag.find_by(name: params[:name])
    if @tag.present?
      tag_recipes = @tag.recipes
      @tag_recipes = Kaminari.paginate_array(tag_recipes).page(params[:page]).per(10)
      @tag_recipes_count = tag_recipes.count
      @tag_search = true
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
