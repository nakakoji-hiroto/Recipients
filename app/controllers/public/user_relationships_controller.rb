class Public::UserRelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_guest_user
  
  def create
    user_relationship = UserRelationship.new(follower_id: current_user.id)
    user_relationship.followed_id = params[:user_id]
    user_relationship.save
    user_name = params[:name]
    flash[:user_relation] = user_name + "さんをフォローしました"
    redirect_to request.referer
  end
  
  def destroy
    user_relationship = UserRelationship.find_by(follower_id: current_user, followed_id: params[:user_id])
    user_relationship.destroy
    user_name = params[:name]
    flash[:user_relation] = user_name + "さんのフォローを解除しました"
    redirect_to request.referer
  end
  
end
