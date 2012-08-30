class ApplicationController < ActionController::Base
  before_filter :authorize
  protect_from_forgery

  protected

  def authorize
    unless User.find_by_id(session[:user_id])
      session[:original_target] = request.url # unless request.url =~ /admin/

      if User.count.zero?
        user = User.create(:name => params[:name],
                            :password => params[:password],
                            :password_confirmation => params[:password])
      end
      redirect_to login_url, notice: 'Please log in'
    end
  end
end
