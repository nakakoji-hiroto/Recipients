class Public::TagsController < ApplicationController
  before_action :authenticate_user!
  #before_action :ensure_guest_user

  def tag_search
    @tag = Tag.find_by(name: params[:name])
    if @tag.present?
      @tag_recipes = @tag.recipes
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
