class ApplicationController < ActionController::Base
  def ensure_guest_user
    if current_user.email == "guest@example.com"
      redirect_to root_path
      flash[:notice] = "ゲストユーザーはこの機能を使用できません！"
      flash[:notice2] = "新規会員登録ページより会員登録を行ってください。"
    end
  end
  
  def check_admin_sign_in
    unless admin_signed_in?
      redirect_to root_path
    end
  end
  
  def identification_user(user, path_name)
    unless user.id == current_user.id
      redirect_to path_name
    end
  end
  
end
