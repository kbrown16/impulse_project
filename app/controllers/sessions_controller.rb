class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user

    else
      flash.now[:danger] = 'You have entered an invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def new
  end

  def destroy
   log_out if logged_in?
    redirect_to root_path
  end

end
