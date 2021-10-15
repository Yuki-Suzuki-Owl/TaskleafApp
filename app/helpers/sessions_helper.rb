module SessionsHelper

  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session.clear
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id:session[:user_id])
  end

  def logged_in?
    # login => true , no login => false
    # !session[:user_id].nil?
    !current_user.nil?
  end
end
