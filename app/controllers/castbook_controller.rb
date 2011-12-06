class CastbookController < ApplicationController
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
    if Person.exists?(params[:id])
      @castbook = Person.find(params[:id])
      @castbook.view_count += 1
      @castbook.save
      @skill = (Skill.where(person_id: @castbook.id)).collect { |s| s.skill_text }.join(', ')
      @credit = Credit.where(person_id: @castbook.id).order(:display_order)
      cast = Person.find(params[:id])
      cast.last_viewed_at = Date.today
      cast.save
    else 
      redirect_to :controller => 'castbook'
    end
    
  end
end
