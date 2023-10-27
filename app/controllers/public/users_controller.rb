class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user

  def index
    @criteria_choice = {投稿レシピが多い順に: 'many_recipes', フォロー数が多い順に: 'many_follows', フォロワー数が多い順に: 'many_followeds'}
    criteria = params[:criteria]
    case criteria
      when 'many_recipes'
        #すべてのユーザーから「有効会員」のみ抽出 >> 各ユーザーが投稿したレシピ数の多い順に並び替え
        filtered_users = User.where(is_active: true).where.not(email: "guest@example.com").includes(:recipes).sort_by { |user| -user.recipes.count }
        #Kaminariでページネーションして,viewページに渡す。
        @users = Kaminari.paginate_array(filtered_users).page(params[:page])
        flash.now[:filter_result] = "投稿レシピが多い順に表示しました。"
        @filtered = true
      when 'many_follows'
        #すべてのユーザーから「有効会員」のみ抽出 >> フォロー数が多い順に並び替え
        filtered_users = User.where(is_active: true).where.not(email: "guest@example.com").includes(:followers).sort_by { |user| -user.followers.count }
        #Kaminariでページネーションして,viewページに渡す。
        @users = Kaminari.paginate_array(filtered_users).page(params[:page])
        flash.now[:filter_result] = "フォロー数が多い順に表示しました。"
        @filtered = true
      when 'many_followeds'
        #すべてのユーザーから「有効会員」のみ抽出 >> フォロワー数が多い順に並び替え
        filtered_users = User.where(is_active: true).where.not(email: "guest@example.com").includes(:followeds).sort_by { |user| -user.followeds.count }
        #Kaminariでページネーションして,viewページに渡す。
        @users = Kaminari.paginate_array(filtered_users).page(params[:page])
        flash.now[:filter_result] = "フォロワー数が多い順に表示しました。"
        @filtered = true
      else
        indicate_users = User.where(is_active: true).where.not(email: "guest@example.com")
        # ステータスが有効会員のユーザーのみページネーションして表示する
        @users = Kaminari.paginate_array(indicate_users).page(params[:page])
        @filtered = false
    end
  end

  def show
    @user = User.find(params[:id])
    # ゲストユーザーの詳細ページは表示させず、マイページへ遷移する
    if @user.email == "guest@example.com"
      redirect_to user_path(current_user)
    end
    # 非公開ユーザーの詳細ページは表示させず、ユーザー一覧ページへ遷移する
    unless @user.is_active
      redirect_to user_path(current_user)
    end
    
    user_recipes = @user.recipes
    indicate_recipes = user_recipes.where(is_release: true)
    # 公開中のレシピのみページネーションして表示する
    @user_recipes = Kaminari.paginate_array(indicate_recipes).page(params[:page]).per(4)
  end

  def edit
    @user = User.find(params[:id])
    #ログイン中のユーザー以外のユーザー情報編集ページを表示させようとした場合、マイページへ遷移させる
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
