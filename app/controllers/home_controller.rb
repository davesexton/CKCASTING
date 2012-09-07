class HomeController < ApplicationController
  skip_before_filter :authorize

  def index
    @carousel = Person.has_image.active.all.sample(21)
  end
end
