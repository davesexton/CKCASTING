class CastbookController < ApplicationController
  before_filter :check_record, :only => [:show]
  def index
    
    # @cast_pages, @castbook = paginate(:people, 
    #   :conditions => "status => 'Active'", 
    #   :order => 'id DESC', 
    #   :per_page => 16)
    @castbook = Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @castbook }
      format.xml {render xml: @castbook }
    end
  end
  
  def show
    # @castbook = Person.find(params[:id])
    @skill = Skill.where(:person_id => @castbook.id)
  end
  
  def check_record
    @castbook = Person.find(params[:id])
    rescue
    flash[:error] = 'Castmember not found'
    redirect_to :controller => 'castbook'
  end
end
