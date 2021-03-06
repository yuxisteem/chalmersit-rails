class SearchController < ApplicationController
  def index
    @search = params[:search]
    if @search
      posts_query = 'post_translations.title LIKE ? or post_translations.body LIKE ?'
      @posts = Post.with_translations(I18n.locale).where(posts_query, "%#{@search}%", "%#{@search}%").ordered
    else
      @posts = []
    end
  end
end
