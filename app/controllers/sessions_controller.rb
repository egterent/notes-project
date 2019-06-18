class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in_and_remember(user)
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def log_in_and_remember(user)
    log_in user
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    flash[:success] = "Welcome back, #{user.name}"
    redirect_back_or user
  end
end
