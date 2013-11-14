class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize

  protected

  def authorize
    unless User.find_by_id(session[:user_id])
      session[:original_target] = request.url

      if User.count.zero?
        user = User.create(name: params[:name],
                            password: params[:password],
                            password_confirmation: params[:password])
      end
      redirect_to login_url, notice: 'Please log in'
    end
  end
end
