class HomeController < ApplicationController
  skip_before_filter :authorize

  def index
    @carousel = Person.has_image.active.all.sample(21)
    @news = Person.has_news.active.all.sample(12)
  end
end
