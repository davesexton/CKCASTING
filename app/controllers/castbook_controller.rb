class CastbookController < ApplicationController
  def index
    #if params[:id]
    #  page = params[:id]
    #else
    #  page = 1
    #end
    #gender = params[:gender]

    page = page.to_i - 1
    page_size = 16
    offset = (page * page_size)
#TODO Add filtering system to castbook

    #@castbook = Person #.where('gender LIKE ?', params[:gender])
    #  .order(:date_of_birth)
    #  .limit(page_size)
    #  .offset(offset)

    #@castbook = Person.active.limit(page_size).offset(offset)

    @nav = (Person.count.to_f / page_size).ceil

    f = Hash.new(0)
    Person.active.count(group: :gender).each{|k, v| f.store(k,"#{k} (#{v})")}
    @gender_group = f.sort.reverse

    h = Hash.new(0)
    f = Hash.new(0)
    m = (Person.all.map {|p| [p.age_group_id, p.age_group] }).uniq.sort
    Person.active.each {|v| h.store(v.age_group_id, h[v.age_group_id]+1) }
    m.each{|k, v| f.store(k, "#{v} (#{h[k]})") }
    @age_group = f

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

  def castlist
    cons = ['status = ?', 'Active']
    if(params[:gender])
      cons[0] += ' AND gender IN(?)'
      cons[cons.length] = params[:gender]
      #Person.find(:all, conditions: ['(last_name in (?)) AND status = ?', ['Fred','Thomas'], 'Active'])
    end
    if(params[:age])
      if params[:age].include?(1)

      end
      #cons[0] += ' AND ()'
    end
    puts cons[0]
    @castbook = Person.where(cons).limit(16).active
    render partial: 'castlist'
  end

  def show
    if Person.exists?(params[:id])
      cast = Person.find(params[:id])

      @castbook = cast
      @skill = (Skill.where(person_id: @castbook.id)).collect {|s| s.skill_text}.join(', ')
      @credit = Credit.where(person_id: @castbook.id).order(:display_order)

      cast = Person.find(params[:id])
      cast.view_count += 1 if (Time.now.utc.to_date - cast.last_viewed_at.to_date).to_i > 1
      cast.last_viewed_at = Time.now.utc
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
