class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    @favorite = current_user.favorites.new(post_id: post.id)
    @favorite.save
    # いいねの通知作成メソッド
    post.create_notification_favorite!(current_user)
    render "replace_btn"
  end

  def destroy
    post = Post.find(params[:post_id])
    @favorite = current_user.favorites.find_by(post_id: post.id)
    @favorite.destroy
    render "replace_btn"
  end
end
