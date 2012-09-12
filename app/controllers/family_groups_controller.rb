class FamilyGroupsController < ApplicationController
  skip_before_filter :authorize

  def index
    valid_ids = Family.all.map{|f| f.id if f.people.count > 1}.uniq
    @family_groups = Family.where('id IN (?) ', valid_ids).order(:family_name)
  end

  def show
    @castlist = Person.where('family_id IN (?)', params[:id]).order([:first_name, :last_name])
    @family_group = Family.find(params[:id])
  end
end
