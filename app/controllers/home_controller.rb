class HomeController < ApplicationController
  skip_before_filter :authorize

  def index
    @news = Person.has_news.active.all.sample(12)
  end

  def carousel
    @carousel = Person.has_image.active.all.sample(21)
      .map{|p| {path: p.path, src: p.carousel_path}}
    respond_to do |format|
      format.json { render json: @carousel}
    end
  end
end
