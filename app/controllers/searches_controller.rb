class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
  end

  def result
    @model = params[:model]
    @content = params[:content]
    if @model == "user"
      @records = User.search_for(@content)
    elsif @model == "post"
      @records = Post.search_for(@content)
    end
  end
end
