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
    
    @castbook = Person.where('gender LIKE ?', params[:gender])
      .order(:date_of_birth)
      .limit(page_size)
      .offset(offset)

    path = './app/assets/images/cast_images/'
    @nav = (Person.count.to_f / page_size).ceil
    
    @castbook.each do |c|
      f = "#{path}#{c.id}.jpg"
      t = f.sub('cast_images', 'cast_thumbs')
      make_thumb f unless FileTest.exist?(t)
    end
    
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
  
  private
  def make_thumb path
    require 'RMagick'
    thumb = path.sub('cast_images', 'cast_thumbs')
    img = Magick::Image::read(path).first
    img = img.crop_resized!(137, 158, Magick::NorthGravity)
    #img = img.thumbnail(0.36)
    img.write(thumb)
  end
end
