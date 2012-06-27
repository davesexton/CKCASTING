class HomeController < ApplicationController
  def index
    @carousel = Person.all.sample(20)
  end
end
