class Admin::HomesController < ApplicationController
  before_action :check_admin_sign_in
  
  def top
    @users = User.page(params[:page]).per(10)
  end
  
end
