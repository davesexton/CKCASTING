class CastbookController < ApplicationController
  def index
    if params[:id]
      page = params[:id]
    else
      page = 1
    end
    gender = params[:gender]
    page = page.to_i - 1
    page_size = 16
    offset = (page * page_size)
#TODO Add filtering system to castbook    
    #@castbook = Person #.where('gender LIKE ?', params[:gender])
    #  .order(:date_of_birth)
    #  .limit(page_size)
    #  .offset(offset)

    @castbook = Person.limit(page_size).offset(offset)

    @nav = (Person.count.to_f / page_size).ceil
    
    @gender_group = Person.count(group: :gender)
    #@age_group = Person.count(group: [:age_group, :age_group_id])

    #@gender_group = Person.count(group: :gender)
    
    #@age_group = Person.count(group: :age_group)

    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        render json: 
         @castbook.as_json(
            only: [:id, :gender], 
            methods: [:full_name, :height_group, :thumbnail_url]) 
      }
      format.xml {
        render xml: @castbook.sample(25).to_xml(
            only: [:id], 
            methods: [:url, :thumbnail_url]) 
      }
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
      redirect_to controller: 'castbook'
    end
    
  end
  
  def random
    @castbook = Person.all
    respond_to do |format|
      format.xml {
        render xml: @castbook.sample(25).to_xml(
            only: [:id], 
            methods: [:url, :carousel_url]) 
      }
    end
  end
end
