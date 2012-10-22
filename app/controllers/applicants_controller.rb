class ApplicantsController < ApplicationController
  skip_before_filter :authorize, only: [:new, :create]
  # GET /applicants
  # GET /applicants.json
  def index
    @applicants = Applicant.order('created_at DESC').paginate(page: params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @applicants }
    end
  end

  # GET /applicants/1
  # GET /applicants/1.json
  def show
    @applicant = Applicant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @applicant }
    end
  end

  # GET /applicants/new
  # GET /applicants/new.json
  def new

    @hair_colour = HairColour.select(:hair_colour).order(:hair_colour).map(&:hair_colour)
    @eye_colour = EyeColour.select(:eye_colour).order(:eye_colour).map(&:eye_colour)

    @applicant = Applicant.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @applicant }
    end
  end

  # GET /applicants/1/edit
  def edit
    @hair_colour = HairColour.select(:hair_colour).order(:hair_colour).map(&:hair_colour)
    @eye_colour = EyeColour.select(:eye_colour).order(:eye_colour).map(&:eye_colour)
    @applicant = Applicant.find(params[:id])
  end

  # POST /applicants
  # POST /applicants.json
  def create
    @hair_colour = HairColour.select(:hair_colour).order(:hair_colour).map(&:hair_colour)
    @eye_colour = EyeColour.select(:eye_colour).order(:eye_colour).map(&:eye_colour)
    @applicant = Applicant.new(params[:applicant])

    respond_to do |format|
      if @applicant.save
        Notifier.join_notifier(@applicant).deliver
        Notifier.join_acknowledge(@applicant).deliver
        format.html { redirect_to home_url,
                      notice: 'Thank you for your application.' }
        format.json { render json: @applicant,
                      status: :created,
                      location: @applicant }
      else
        format.html { render action: "new" }
        format.json { render json: @applicant.errors,
                      status: :unprocessable_entity }
      end
    end
  end

  # PUT /applicants/1
  # PUT /applicants/1.json
  def update
    @hair_colour = HairColour.select(:hair_colour).order(:hair_colour).map(&:hair_colour)
    @eye_colour = EyeColour.select(:eye_colour).order(:eye_colour).map(&:eye_colour)
    @applicant = Applicant.find(params[:id])

    respond_to do |format|
      if @applicant.update_attributes(params[:applicant])
        format.html { redirect_to @applicant, notice: 'Applicant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @applicant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applicants/1
  # DELETE /applicants/1.json
  def destroy
    @applicant = Applicant.find(params[:id])
    @applicant.destroy

    respond_to do |format|
      format.html { redirect_to applicants_url }
      format.json { head :no_content }
    end
  end
end
