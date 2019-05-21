class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in_user
   unless logged_in?
     store_location
     flash[:danger] = "Zaloguj się."
     redirect_to login_url
   end
 end

end
