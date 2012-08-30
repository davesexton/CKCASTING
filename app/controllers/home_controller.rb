class HomeController < ApplicationController
  skip_before_filter :authorize
  def index
    @carousel = Person.all.sample(21)
  end
end
