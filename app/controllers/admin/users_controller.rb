class Admin::UsersController < ApplicationController
  before_action :check_admin_sign_in

  def show
    @user = User.find(params[:id])
    @user_recipes = @user.recipes
  end

  def update
    @user = User.find(params[:id])
    if @user.is_active
      @user.is_active = false
      @user.save
      flash.now[:is_active_changed] = '※会員ステータスを利用停止に変更しました'
    else
      @user.is_active = true
      @user.save
      flash.now[:is_active_changed] = '※会員ステータスを有効会員に変更しました'
    end
  end
end
