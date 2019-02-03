class SessionsController < ApplicationController


  def new
  end

  def create
    user = User.find_by(email: params[:user][:email])
    if user&.authenticate(params[:user][:password]) then
      login user
      redirect_to root_path
      if params[:user][:remember_me] == '1'
        remember user
      else
        forget user
      end
    else
      flash[:warning] = "Incorrect email / password combination"
      redirect_to login_path
    end
  end

  def destroy
    @user = current_user
    if logged_in? @user
      logout @user
      flash[:notice] = "User: #{@user.name} logged out"
    end
    redirect_to root_path
  end
end
