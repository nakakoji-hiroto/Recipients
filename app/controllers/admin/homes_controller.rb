class Admin::HomesController < ApplicationController
  before_action :check_admin_sign_in
  
  def top
    @criteria_choice = {投稿レシピが多い順に: 'many_recipes', フォロー数が多い順に: 'many_follows', フォロワー数が順に: 'many_followeds'}
    criteria = params[:criteria]
    case criteria
      when 'many_recipes'
        #各ユーザーが投稿したレシピ数の多い順に並び替え >> 管理者画面の為、会員のステータスに関わらず表示する。
        filtered_users = User.includes(:recipes).sort_by { |user| -user.recipes.count }
        #Kaminariでページネーションして,viewページに渡す。
        @users = Kaminari.paginate_array(filtered_users).page(params[:page]).per(10)
        flash.now[:filter_result] = "投稿レシピが多い順に表示しました。"
        @filtered = true
      when 'many_follows'
        #フォロー数が多い順に並び替え >> 管理者画面の為、会員のステータスに関わらず表示する。
        filtered_users = User.includes(:followers).sort_by { |user| -user.followers.count }
        #Kaminariでページネーションして,viewページに渡す。
        @users = Kaminari.paginate_array(filtered_users).page(params[:page]).per(10)
        flash.now[:filter_result] = "フォロー数が多い順に表示しました。"
        @filtered = true
      when 'many_followeds'
        #フォロワー数が多い順に並び替え >> 管理者画面の為、会員のステータスに関わらず表示する。
        filtered_users = User.includes(:followeds).sort_by { |user| -user.followeds.count }
        #Kaminariでページネーションして,viewページに渡す。
        @users = Kaminari.paginate_array(filtered_users).page(params[:page]).per(10)
        flash.now[:filter_result] = "フォロワー数が多い順に表示しました。"
        @filtered = true
      else
        @users = User.page(params[:page]).per(10)
        @filtered = false
    end
  end
end
