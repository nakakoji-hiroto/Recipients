class Public::ChatsController < ApplicationController
  before_action :reject_non_related, only: [:show]
  
  def show
    @user = User.find(params[:id])
    #ログイン中のユーザーの所属ルーム情報を全て取得する
    rooms = current_user.user_rooms.pluck(:room_id)
    #取得した情報の中にターゲットユーザーとのルームがあるか確認する
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    #該当のルームが見つかれば変数に代入し、見つからなければ新規作成したうえで、変数に代入する。
    unless user_rooms.nil?
      @room = user_rooms.room
    else
      @room = Room.new
      @room.save
    #自分側、相手ユーザー側のユーザールームをそれぞれ新規作成する
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    @chats = @room.chats.order('id DESC').page(params[:page]).per(20)
    @chat = Chat.new(room_id: @room.id)
  end
  
  def create
    @chat = current_user.chats.new(chat_params)
    unless @chat.save
      render :error
    end
  end

  private
  
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def reject_non_related
    user = User.find(params[:id])
    #相手ユーザーと相互フォロー状態でないか、相手ユーザーの会員ステータスが「利用停止」の場合、ログインユーザーのマイページに遷移させる
    unless current_user.followed_by?(user) && user.followed_by?(current_user) && user.is_active
      redirect_to user_path(current_user)
    end
  end
  
end
