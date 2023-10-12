class Admin::HomesController < ApplicationController
  before_action :check_admin_sign_in
  
  def top
    @users = User.all
  end
  
  private
  
  def check_admin_sign_in
    unless admin_signed_in?
      redirect_to root_path
    end
  end
end
