class FriendshipsController < ApplicationController
  before_action :friendship_params ,only: [:create]
  before_action :set_friendship ,only: [:destroy, :cancel]
  before_action :set_inverse_friendship ,only: [:create, :accept, :ignore, :destroy]
  before_action :set_target_user ,only: [:create, :destroy, :accept, :cancel, :ignore]
  before_action :set_user ,only: [:check]

  def create
    if @inverse_friendship.nil? #target didn't sent request => you can friend them

      @friendship = current_user.friendships.build(friendship_params)
      @friendship.save
    end
  end

  def destroy
    if @friendship.nil? #still friend, current_user's id==friend_id in friend db
      @inverse_friendship.destroy

    else #still friend, current_user's id==user_id in friend db
      @friendship.destroy
    end
  end

  def accept
    @inverse_friendship.update_attributes(status: 'confirmed')
  end

  def cancel
    @friendship.destroy
  end

  def ignore
    @inverse_friendship.destroy
  end

  def check
    @unconfirmed_friends = current_user.unconfirmed_friends
    @unconfirmed_inverse_friends = current_user.unconfirmed_inverse_friends
  end

  private

  def friendship_params
    params.permit(:friend_id)
  end

  def set_friendship
    @friendship = current_user.friendships.find_by(friend_id: params[:id])
  end

  def set_inverse_friendship
    @inverse_friendship = current_user.inverse_friendships.find_by(user_id: params[:id])
  end

  def set_target_user
    id = params[:id] || params[:friend_id]
    @target_user = User.find(id)
  end

  def set_user
    @user = User.find(params[:id])
  end

end