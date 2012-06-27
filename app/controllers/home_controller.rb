class HomeController < ApplicationController
  def index
    @carousel = Person.all.sample(21)
  end
end
