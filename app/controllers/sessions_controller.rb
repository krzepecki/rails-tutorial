class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
   if @user && @user.authenticate(params[:session][:password])
     if @user.activated?
       log_in @user
       params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
       redirect_back_or @user
     else
       message  = "Konto nieaktywne. "
       message += "Sprawdź adres email i wiadomość z linkiem aktywacyjnym."
       flash[:warning] = message
       redirect_to root_url
     end
   else
     flash.now[:danger] = "Podano złe dane do logowania"
     render 'new'
   end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
