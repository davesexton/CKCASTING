class CastbookController < ApplicationController
def index
    
   # @cast_pages, @castbook = paginate(:people, 
   #   :conditions => "status => 'Active'", 
   #   :order => 'id DESC', 
   #   :per_page => 16)
    @castbook = Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @castbook }
    end
  end
  
  def show
    @castbook = Person.find(params[:id])
  end
end
