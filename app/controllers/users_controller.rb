class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :quit, :destroy]
  before_action :ensure_guest_user, only: [:edit]

  def index
    @users = User.page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(12)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  def quit
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end

  # いいねした投稿一覧
  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Kaminari.paginate_array(Post.find(favorites)).page(params[:page]).per(12)
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image, :email)
  end

    # 管理者もしくは本人以外にユーザーを更新させない
  def ensure_correct_user
    @user = User.find(params[:id])
    if (current_user.admin? == false) && (current_user != @user)
      redirect_to user_path(current_user)
    end
  end

  # 管理者以外はゲストユーザーの編集画面に遷移できない
  def ensure_guest_user
    @user = User.find(params[:id])
    if (@user.name == "guestuser") && (current_user.admin? == false)
      redirect_to user_path(current_user), notice: "Invalid action."
    end
  end
end
