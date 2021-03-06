class PeopleController < ApplicationController
  # GET /people
  # GET /people.json
  def index
    @people = Person.order(:status, :last_name)
    @summary = Person.group(:status).count.map{ |k, v| "#{v} #{k}" }.join(' and ')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @people }
      format.csv
      format.xml do
        stream = render_to_string(template: 'people/index' )
        send_data(stream, type: 'applicatiom/xml',
                          filename: 'castlist.xls')
        end
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @person = Person.find(params[:id])
    @hair_colours = Person.get_hair_colours
    @eye_colours = Person.get_eye_colours
    @heights_feet = Person.get_heights_feet
    @heights_inches = Person.get_heights_inches
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/new
  # GET /people/new.json
  def new
    @person = Person.new
    @hair_colours = Person.get_hair_colours
    @eye_colours = Person.get_eye_colours
    @heights_feet = Person.get_heights_feet
    @heights_inches = Person.get_heights_inches

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
    @hair_colours = Person.get_hair_colours
    @eye_colours = Person.get_eye_colours
    @heights_feet = Person.get_heights_feet
    @heights_inches = Person.get_heights_inches

    rescue ActiveRecord::RecordNotFound
      redirect_to people_url, notice: 'Cast member not found'
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(params[:person])
    @heights_feet = Person.get_heights_feet
    @heights_inches = Person.get_heights_inches
    @hair_colours = Person.get_hair_colours
    @eye_colours = Person.get_eye_colours

    respond_to do |format|
      if @person.save
        @person.skill_list = params[:person][:skill_list]
        @person.credit_list = params[:person][:credit_list]
        @person.image_upload = params[:person][:image_upload]
        @person.save
        format.html { redirect_to people_url,
                    notice: "Cast member #{@person.full_name} was successfully created" }
        format.json { render json: @person,
                      status: :created, location: @person }
      else
        format.html { render action: "new" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.json
  def update
    @person = Person.find(params[:id])
    @hair_colours = Person.get_hair_colours
    @eye_colours = Person.get_eye_colours
    @heights_feet = Person.get_heights_feet
    @heights_inches = Person.get_heights_inches

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to people_url,
                  notice: "Cast member #{@person.full_name} was successfully updated." }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @person.errors,
                      status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to people_url }
      format.json { head :ok }
    end
  end

  def deactivate
    @person = Person.find(params[:id])
    @person.status = 'Inactive'
    @person.save

    respond_to do |format|
      format.html { redirect_to people_url,
              notice: "Cast member #{@person.full_name} was successfully deactivated." }
      format.json { head :ok }
    end
  end

  def activate
    @person = Person.find(params[:id])
    @person.status = 'Active'
    @person.save

    respond_to do |format|
      format.html { redirect_to people_url,
                notice: "Cast member #{@person.full_name} was successfully activated." }
      format.json { head :ok }
    end
  end

end
