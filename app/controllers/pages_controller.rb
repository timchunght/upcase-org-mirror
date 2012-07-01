class PagesController < ApplicationController
  def home
    @books = Product.active.where("product_type LIKE '%book%'")
    @screencasts = Product.active.where("product_type LIKE '%screencast%'")
    @courses = Course.only_public.by_position
    @topics = Topic.all
    @articles = Article.all
  end
end
