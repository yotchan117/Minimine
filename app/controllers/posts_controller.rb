class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
    @tag_list = nil
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
    # デフォルトはフォローしているユーザー＋自分の投稿一覧。リンクをクリックすると表示方法を切り替え。
    @posts = Post.where(user_id: [current_user.id, *current_user.following_ids]).order(created_at: :desc).page(params[:page]).per(12)
    if params[:following]
      @posts = Post.where(user_id: [current_user.id, *current_user.following_ids]).order(created_at: :desc).page(params[:page]).per(12)
    elsif params[:latest]
      @posts = Post.order(created_at: :desc).page(params[:page]).per(12)
    elsif params[:popular]
      @posts = Kaminari.paginate_array(Post.find(Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id))).page(params[:page]).per(12)
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
    @tag_list = @post.tags.pluck(:name).join(",")
  end

  def update
    tag_list = params[:post][:tag_name].split(",")
    if @post.update(post_params)
      @post.save_tags(tag_list)
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
