class Public::UserRelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  
  def create
    @user = User.find(params[:user_id])
    user_relationship = UserRelationship.new(follower_id: current_user.id)
    user_relationship.followed_id = params[:user_id]
    user_relationship.save
    flash.now[:user_relation] = @user.name + "さんをフォローしました"
  end
  
  def destroy
    @user = User.find(params[:user_id])
    user_relationship = UserRelationship.find_by(follower_id: current_user, followed_id: params[:user_id])
    user_relationship.destroy
    flash.now[:user_relation] = @user.name + "さんのフォローを解除しました"
  end
  
end
