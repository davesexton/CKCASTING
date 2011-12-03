class CastbookController < ApplicationController
  before_filter :check_record, :only => [:show]
  
  def index
    @castbook = Person.order(:date_of_birth).all
    @gender_group = Person.count(group: :gender)
    #@gender_group = Person.count(group: :gender)
    
    
    #@age_group = Person.count(group: :age_group)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @castbook }
      format.xml {render xml: @castbook }
    end
  end
  
  def show
    # @castbook = Person.find(params[:id])
    @skill = (Skill.where(person_id: @castbook.id)).collect { |s| s.skill_text }.join(', ')
    @credit = Credit.where(person_id: @castbook.id).order(:display_order)
  end
  
  def check_record
    @castbook = Person.find(params[:id])
    rescue
    flash[:error] = 'Castmember not found'
    redirect_to :controller => 'castbook'
  end
end
