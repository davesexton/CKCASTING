class CastbookController < ApplicationController
  skip_before_filter :authorize

  def index
    @castlist = Person.active.order('date_of_birth DESC').paginate(page: 1, per_page: 16)

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
         @castlist.as_json(
            only: [:id, :gender],
            methods: [:full_name, :height_group, :thumbnail_path])
      }
      format.xml {
        render xml: @castlist.to_xml(
            only: [:id],
            methods: [:url, :thumbnail_path])
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

# Add family group
    if params[:family]
#      cons[0] += ' AND family_id NOT ? '
#      cons << nil

      cons[0] += ' AND family_id > ? '
      cons << 0
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

    castlist = Person.where(cons).active.order('date_of_birth DESC').paginate(page: params[:page], per_page: 16)
    render partial: 'shared/castlist', locals: {castlist: castlist}
  end

  def show
    if Person.exists?(params[:id])
      cast = Person.find(params[:id])

      @castbook = cast

      cast.update_last_viewed_at

      respond_to do |format|
        format.html # new.html.erb
        format.pdf do
          pdf_attrb = {
            margin: 50,
            info: {
                  Title: cast.full_name,
                  Author: "CK Casting",
                  Subject: "Cast sheet for #{cast.full_name}",
                  Keywords: "ckcasting casting agency",
                  Creator: "www.ckcasting.co.uk",
                  Producer: "www.ckcasting.co.uk",
                  CreationDate: Time.now
                  },
            page_size: 'A4'}
          pdf = CastDocument.new(pdf_attrb).to_pdf(@castbook)
          send_data pdf,
                    filename: "#{cast.pdf_name}.pdf",
                    type: "application/pdf",
                    disposition: "inline"
        end
        format.json { render json: @castbook }
      end

    else
      redirect_to controller: 'castbook'
    end

  end

  private

  class CastDocument < Prawn::Document
    def to_pdf(cast)
      #text "left: #{bounds.left} right: #{bounds.right}"

      y_position = cursor
      default_leading 10

      c1 = "<color rgb='999999'>"
      ce = "</color>"

      fill_color '999999'
      rounded_rectangle [0, y_position - 385], 495, 2, 1 if cast.credits.any?
      rounded_rectangle [250, y_position - 105], 240, 4, 2
      rounded_rectangle [0, 95], 495, 2, 1

      bounding_box([0, y_position], width: 495) do
        cell content: '.',
             background_color: '666666',
             border_width: 0,
             width: 495,
             text_color: "666666",
             font_style: :bold,
             size: 40
        cell content: 'C K   C A S T I N G',
             border_width: 0,
             text_color: "ffffff",
             font_style: :bold,
             size: 40,
             x: 10,
             y: -22

      end

      image Rails.root.join('public', 'cast_image_frame.png'),
              width: 260,
              at: [-13, y_position - 65]

      image cast.pdf_image_path,
            width: 214,
            at: [10, y_position - 91]

      bounding_box([250, y_position - 80], width: 245) do
        fill_color '999999'
        font "Helvetica", style: :bold
        font_size 20
        text cast.full_name

        fill_color '222222'
        font "Helvetica", style: :normal
        font_size 12
        move_down 15
        text "#{c1}Gender:#{ce} #{cast.gender}",
             inline_format: true
        text "#{c1}Hair Colour:#{ce} #{cast.hair_colour}",
             inline_format: true
        text "#{c1}Eye Colour:#{ce} #{cast.eye_colour}",
             inline_format: true
        text "#{c1}Height:#{ce} #{cast.height_feet}' #{cast.height_feet}\"",
             inline_format: true
        move_down 15
        text "#{c1}URL:#{ce} <link href='#{cast.full_url}'>#{cast.full_url}</link>",
             inline_format: true
        move_down 15

        y = cursor

        bounding_box([0, y], width: 35) do
          text "#{c1}Skills:#{ce}", inline_format: true
        end if cast.skills.any?
        default_leading 2
        bounding_box([35, y + 26], width: 195) do
          text "#{cast.skill_list}"
        end if cast.skills.any?

      end

      default_leading 5
      bounding_box([0, y_position - 370], width: 490) do
        if cast.credits.any?
          if cast.credits.size == 1
            text "#{c1}Credit:#{ce}", inline_format: true
          else
            text "#{c1}#{cast.credits.size} Credits:#{ce}", inline_format: true
          end
          move_down 10
          cast.credits.each do |c|
            y = cursor
            fill_color '999999'
            fill_circle [3, y - 4], 3
            fill_color '222222'
            bounding_box([13, y], width: 430) do
              text " #{c.credit_item_text}"
            end
          end
        end
      end

      fill_color '999999'
      bounding_box([0, 110], width: 400) do
        text "CONTACT INFORMATION"
      end

      fill_color '222222'
      font_size 10
      default_leading 2
      bounding_box([10, 80], width: 153) do
        text "<link href='www.ckcasting.co.uk'>www.ckcasting.co.uk</link>",
             inline_format: true, align: :center
      end
      bounding_box([163, 80], width: 163) do
        text "Carmel Thomas", align: :center
        text "01371-851-164", align: :center
        text "07944-955-186", align: :center
        move_down 5
        text "Charlotte Turner-Kersley", align: :center
        text "07970-902-640", align: :center
      end
      bounding_box([336, 80], width: 150) do
        text "Parkview", align: :center
        text "1 School Road", align: :center
        text "Blackmore End", align: :center
        text "Essex", align: :center
        text "CM7 4DN", align: :center
      end
      render
    end
  end

end
