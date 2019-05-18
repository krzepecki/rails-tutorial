class PasswordResetsController < ApplicationController

  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

def new
end

def create
  @user = User.find_by(email: params[:password_reset][:email].downcase)
  if @user
    @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Wysłano wiadomość z linkiem resetującym hasło."
      redirect_to root_url
  else
    flash.now[:danger] = "Błędny adres email."
    render 'new'
  end
end

def edit
end

def update
   if params[:user][:password].empty?                  # Case (3)
     @user.errors.add(:password, "Nie może być puste")
     render 'edit'
   elsif @user.update_attributes(user_params)          # Case (4)
     log_in @user
     @user.update_columns(reset_digest: nil, reset_sent_at: nil)
     flash[:success] = "Hasło zostało zresetowane"
     redirect_to @user
   else
     render 'edit'                                     # Case (2)
   end
end
private

def user_params
   params.require(:user).permit(:password, :password_confirmation)
 end

def get_user
  @user = User.find_by(email: params[:email])
end

# Confirms a valid user.
def valid_user
  unless (@user && @user.activated? &&
          @user.authenticated?(:reset, params[:id]))
    redirect_to root_url
  end
end

def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
end
end
