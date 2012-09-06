class HomeController < ApplicationController
  skip_before_filter :authorize
#TODO add home page code to only show cast with an image on the carousel
  def index
    @carousel = Person.has_image.active.all.sample(21)
  end
end
