class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
  end

  def result
    @model = params[:model]
    @content = params[:content]
    # 検索フォームが空欄の場合画面遷移しない
    if @content.empty?
      render "search"
    end

    if @model == "post"
      @records = Post.search_for(@content)
    elsif @model == "user"
      @records = User.search_for(@content)
    end
  end
end
