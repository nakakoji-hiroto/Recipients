class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @user_recipes = @user.recipes
  end

  def edit
    @user = User.find(params[:id])
    identification_user(@user, user_path(current_user))
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "会員情報を更新しました"
    else
      render 'edit'
      #redirect_to edit_user_path(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
