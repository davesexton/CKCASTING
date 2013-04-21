class AdminController < ApplicationController
  def index
    @user = User.find(session[:user_id])
  end

  def backup

    str = Person.to_rb
    str += Family.to_rb
    str += Credit.to_rb
    str += Skill.to_rb
    str += User.to_rb
    str += HairColour.to_rb
    str += EyeColour.to_rb
    str += Applicant.to_rb

    str = "<pre># encoding: utf-8\n#{str}\n</pre>"

    respond_to do |format|
      format.html {render text: str }
    end
  end
end
