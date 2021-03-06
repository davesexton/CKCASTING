class FamilyGroupsController < ApplicationController
  skip_before_filter :authorize

  def index
    valid_ids = Family.all.map{|f| f.id if f.people.count > 1}.uniq
    @family_groups = Family.where('id IN (?) ', valid_ids)
      .order(:family_name)
      .paginate(page: params[:page], per_page: 16)
  end

  def show
    @castlist = Person.where('family_id IN (?)', params[:id])
      .order([:first_name, :last_name])
    @family_group = Family.find(params[:id])
  end

  def family_thumbnail
    respond_to do |format|
      format.jpg do
        require 'RMagick'
        path = Rails.root.join('public', 'family_images', "#{params[:image_name]}.jpg")
        path = Rails.root.join('public', 'images', 'default_cast_image.jpg' ) unless
            FileTest.exists?(path)
        img = Magick::Image::read(path).first
        img.crop_resized!(137, 158, Magick::NorthGravity)
        send_data img.to_blob, type: img.mime_type, disposition: :inline
      end
      format.any {render text: 'Not found', status: 404}
    end

  end

end
