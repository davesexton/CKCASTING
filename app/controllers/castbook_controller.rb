class CastbookController < ApplicationController
  skip_before_filter :authorize
  def index
    session[:page] = 1 unless session[:page]
    if params[:id]
      page = params[:id]
    else
      page = session[:page]
    end

    #page = page.to_i - 1
    page_size = 16
    offset = page * page_size

    @castbook = Person.active.limit(page_size).offset(offset)

    @nav = (Person.count / page_size.to_f).ceil

    @page = page

# data for gender checkboxes
    f = Hash.new(0)
    Person.active.count(group: :gender).each{|k, v| f.store(k,"#{k} (#{v})")}
    @gender_group = f.sort.reverse

# data for age checkboxes
    h = Hash.new(0)
    f = Hash.new(0)
    Person.active.each {|v| h.store(v.age_group_id, h[v.age_group_id]+1) }
    (Person.age_groups.map {|p| [p[:id], p[:text]] }).each{|k, v| f.store(k, "#{v} (#{h[k]})") }
    @age_group = f

# data for height checkboxes
    h = Hash.new(0)
    f = Hash.new(0)
    Person.active.each {|v| h.store(v.height_group_id, h[v.height_group_id]+1) }
    (Person.height_groups.map {|p| [p[:id], p[:text]] }).each{|k, v| f.store(k, "#{v} (#{h[k]})") }
    @height_group = f

# data for hair colour checkboxes
    h = Hash.new(0)
    f = Hash.new(0)
    Person.active.where('hair_colour IS NOT NULL').each {|v| h.store(v.hair_colour_group, h[v.hair_colour_group]+1) }
    h.each{|k, v| f.store(k, "#{k} (#{v})") }
    @hair_group = f.sort

# data for eye colour checkboxes
    f = Hash.new(0)
    Person.active.where('eye_colour IS NOT NULL').count(group: :eye_colour).each{|k, v| f.store(k,"#{k} (#{v})")}
    @eye_group = f.sort

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
    page_size = 16
# Add gender parameters
    if params[:gender]
      cons[0] += ' AND gender IN(?)'
      cons << params[:gender]
    end

# Add age parameters
    if params[:age]
      s = []
      g = Person.age_groups
      params[:age].each do |i|
        s << '( date_of_birth BETWEEN ? AND ? )'
        cons << g[i.to_i][:from]
        cons << g[i.to_i][:to]
      end
      cons[0] += " AND (#{s.join(' OR ')})"
    end

# Add height parameters
    if params[:height]
      s = []
      g = Person.height_groups
      params[:height].each do |i|
        s << '( (height_feet * 12) + height_inches BETWEEN ? AND ? )'
        cons << g[i.to_i][:from]
        cons << g[i.to_i][:to]
      end
      cons[0] += " AND (#{s.join(' OR ')})"
    end

# Add hair parameters
    if params[:hair]
      s = []
      params[:hair].each do |i|
        s << '(hair_colour LIKE ? )'
        cons << "%#{i}"
      end
      cons[0] += " AND (#{s.join(' OR ')})"
    end

# Add eye parameters
    if params[:eye]
      cons[0] += ' AND eye_colour IN(?)'
      cons << params[:eye]
    end

# Paging
    session[:page] = params[:page] if params[:page]

    @pages = (Person.where(cons).active.count / page_size) + 1
    session[:page] = '1' if session[:page].to_i > @pages

    @castbook = Person.where(cons).limit(page_size).offset((session[:page].to_i - 1) * page_size).active

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
