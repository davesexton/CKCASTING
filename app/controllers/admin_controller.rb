class AdminController < ApplicationController
  def index
    @user = User.find(session[:user_id])
  end

  def backup

    str = Person.seed_output
    str += Credit.seed_output
    str += Skill.seed_output
    str += User.seed_output
    str += HairColour.seed_output
    str += EyeColour.seed_output

    str = "<pre># encoding: utf-8\n#{str}\n</pre>"

    respond_to do |format|
      format.html {render text: str }
    end
  end
end
