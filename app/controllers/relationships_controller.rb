class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    # フォローの通知作成メソッド
    user.create_notification_follow!(current_user)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    redirect_back(fallback_location: root_path)
  end

  def followings
    user = User.find(params[:user_id])
    @users = user.followings.order("relationships.created_at desc").page(params[:page]).per(20)
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers.order("relationships.created_at desc").page(params[:page]).per(20)
  end
end
