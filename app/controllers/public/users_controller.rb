class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  
  def index
    indicate_users = User.where(is_active: true)
    # ステータスが有効会員のユーザーのみページネーションして表示する
    @users = Kaminari.paginate_array(indicate_users).page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    user_recipes = @user.recipes
    indicate_recipes = user_recipes.where(is_release: true)
    # 公開中のレシピのみページネーションして表示する
    @user_recipes = Kaminari.paginate_array(indicate_recipes).page(params[:page]).per(4)
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
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
