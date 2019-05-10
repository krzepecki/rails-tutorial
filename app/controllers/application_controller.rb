class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end

end
