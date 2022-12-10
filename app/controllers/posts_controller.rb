class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    tag_list = params[:post][:tag_name].split(",")
    if @post.save
      @post.save_tags(tag_list)
      redirect_to post_path(@post), notice: "You have created post successfully."
    else
      render "new"
    end
  end

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "You have updated post successfully."
    else
      render "edit"
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "You have deleted post successfully."
  end

  private

  def post_params
    params.require(:post).permit(:image, :description)
  end

  def ensure_correct_user
    # 管理者もしくは本人以外に投稿を更新させない
    @post = Post.find(params[:id])
    if (current_user.admin? == false) && (current_user != @post.user)
      redirect_to posts_path
    end
  end
end
