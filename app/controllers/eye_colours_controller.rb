class EyeColoursController < ApplicationController
  # GET /eye_colours
  # GET /eye_colours.json
  def index
    @eye_colours = EyeColour.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @eye_colours }
    end
  end

  # GET /eye_colours/1
  # GET /eye_colours/1.json
  def show
    @eye_colour = EyeColour.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @eye_colour }
    end
  end

  # GET /eye_colours/new
  # GET /eye_colours/new.json
  def new
    @eye_colour = EyeColour.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @eye_colour }
    end
  end

  # GET /eye_colours/1/edit
  def edit
    @eye_colour = EyeColour.find(params[:id])
  end

  # POST /eye_colours
  # POST /eye_colours.json
  def create
    @eye_colour = EyeColour.new(params[:eye_colour])

    respond_to do |format|
      if @eye_colour.save
        format.html { redirect_to @eye_colour, notice: 'Eye colour was successfully created.' }
        format.json { render json: @eye_colour, status: :created, location: @eye_colour }
      else
        format.html { render action: "new" }
        format.json { render json: @eye_colour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /eye_colours/1
  # PUT /eye_colours/1.json
  def update
    @eye_colour = EyeColour.find(params[:id])

    respond_to do |format|
      if @eye_colour.update_attributes(params[:eye_colour])
        format.html { redirect_to @eye_colour, notice: 'Eye colour was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @eye_colour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /eye_colours/1
  # DELETE /eye_colours/1.json
  def destroy
    @eye_colour = EyeColour.find(params[:id])
    @eye_colour.destroy

    respond_to do |format|
      format.html { redirect_to eye_colours_url }
      format.json { head :ok }
    end
  end
end
