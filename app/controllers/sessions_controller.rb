class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email:params[:session][:email])
    if user&.authenticate(params[:session][:password])
      login user
      flash[:success] = "Log in!"
      redirect_to tasks_path
    else
      flash.now[:danger] = "wrong email or password."
      render "new"
    end
  end

  def destroy
    logout
    redirect_to login_path
  end
end
