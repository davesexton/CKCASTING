class CastbooksController < ApplicationController
  # GET /castbooks
  # GET /castbooks.json
  def index
    @castbooks = Castbook.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @castbooks }
    end
  end

  # GET /castbooks/1
  # GET /castbooks/1.json
  def show
    @castbook = Castbook.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @castbook }
    end
  end

  # GET /castbooks/new
  # GET /castbooks/new.json
  def new
    @castbook = Castbook.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @castbook }
    end
  end

  # GET /castbooks/1/edit
  def edit
    @castbook = Castbook.find(params[:id])
  end

  # POST /castbooks
  # POST /castbooks.json
  def create
    @castbook = Castbook.new(params[:castbook])

    respond_to do |format|
      if @castbook.save
        format.html { redirect_to @castbook, notice: 'Castbook was successfully created.' }
        format.json { render json: @castbook, status: :created, location: @castbook }
      else
        format.html { render action: "new" }
        format.json { render json: @castbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /castbooks/1
  # PUT /castbooks/1.json
  def update
    @castbook = Castbook.find(params[:id])

    respond_to do |format|
      if @castbook.update_attributes(params[:castbook])
        format.html { redirect_to @castbook, notice: 'Castbook was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @castbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /castbooks/1
  # DELETE /castbooks/1.json
  def destroy
    @castbook = Castbook.find(params[:id])
    @castbook.destroy

    respond_to do |format|
      format.html { redirect_to castbooks_url }
      format.json { head :ok }
    end
  end
end
