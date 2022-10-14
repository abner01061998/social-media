class FriendshipsController < ApplicationController
  before_action :user_friends

  def index
  end

  def search_friend
    @users = User.where('first_name like ? ', "%#{params[:input]}%").or(User.where('last_name like ? ', "%#{params[:input]}%")).or(User.where('email like ? ', "%#{params[:input]}%")).and(User.where.not(id: current_user.id))
    respond_to do |format|
      format.html { render partial: 'preview_list'}
    end
  end

  def create
    respond_to do |format|
      if !current_user.friends.where(id: params[:user]).exists?
        if current_user.friendships.build(friend_id: params[:user]).save
          flash.now[:success] = 'Friend added'
        else
          flash.now[:alert] = "Can't add #{user.full_name} as friend"
        end
      else
        flash.now[:notice] = 'Already added as friend'
      end
        format.html { render partial: 'list'}
    end
  end

  def destroy
    respond_to do |format|
      if current_user.friendships.where(friend_id: params[:id]).delete_all
        flash.now[:success] = 'Friend unfollowed successfully'
      else
        flash.now[:alert] = "Can't unfollow friend"
      end
      format.html { render partial: 'list'}
    end
  end

  private
  def user_friends
    @friends = current_user.friends
  end
end