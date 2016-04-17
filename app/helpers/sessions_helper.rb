module SessionsHelper

  #Logs in a given user.
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #Remembers a user
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  #Returns the current user (if any).
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  def current_property
    @current_property ||= Property.find_by(params[:id])
  end
  
  #Returns true if the user is logged in.
  def logged_in?
    !current_user.nil?
  end
  
  #Forgets a persisten session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  #Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end
  
  #Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  #Redirects to a stored location
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

end
