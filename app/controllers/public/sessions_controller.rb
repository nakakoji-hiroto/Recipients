# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :check_invalid_user, only: [:create]
  
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to root_path, notice: "ゲストユーザーでログインしました。"
  end
  
  def check_invalid_user
    user = User.find_by(email: params[:user][:email])
    if user && user.valid_password?(params[:user][:password])
      unless user.is_active
        flash[:alert] = "このアカウントは利用停止中につき使用できません"
        redirect_to new_user_session_path
      end
    else
      return
    end
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
