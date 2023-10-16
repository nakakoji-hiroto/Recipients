class Admin::HomesController < ApplicationController
  before_action :check_admin_sign_in
  
  def top
    @users = User.all
  end
  
end
