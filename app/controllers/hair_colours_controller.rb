class HairColoursController < ApplicationController
  # GET /hair_colours
  # GET /hair_colours.json
  def index
    @hair_colours = HairColour.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hair_colours }
    end
  end

  # GET /hair_colours/1
  # GET /hair_colours/1.json
  def show
    @hair_colour = HairColour.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @hair_colour }
    end
  end

  # GET /hair_colours/new
  # GET /hair_colours/new.json
  def new
    @hair_colour = HairColour.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @hair_colour }
    end
  end

  # GET /hair_colours/1/edit
  def edit
    @hair_colour = HairColour.find(params[:id])
  end

  # POST /hair_colours
  # POST /hair_colours.json
  def create
    @hair_colour = HairColour.new(params[:hair_colour])

    respond_to do |format|
      if @hair_colour.save
        format.html { redirect_to @hair_colour, notice: 'Hair colour was successfully created.' }
        format.json { render json: @hair_colour, status: :created, location: @hair_colour }
      else
        format.html { render action: "new" }
        format.json { render json: @hair_colour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /hair_colours/1
  # PUT /hair_colours/1.json
  def update
    @hair_colour = HairColour.find(params[:id])

    respond_to do |format|
      if @hair_colour.update_attributes(params[:hair_colour])
        format.html { redirect_to @hair_colour, notice: 'Hair colour was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @hair_colour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hair_colours/1
  # DELETE /hair_colours/1.json
  def destroy
    @hair_colour = HairColour.find(params[:id])
    @hair_colour.destroy

    respond_to do |format|
      format.html { redirect_to hair_colours_url }
      format.json { head :ok }
    end
  end
end
