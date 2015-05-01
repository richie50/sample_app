module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    #sessions[:user_id] = user_id
    self.current_user = user;
  end
  
  #maybe this is the bug -> not remembering users on both production and developing servers
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end 
  
  def signed_in?
    #note if you dont do the negation of current_user going back to the home page
    #still shows that we are logged in if we access accounts directly
    #we might not want this in some cases because it still shows account link on the homepage
   !current_user.nil?
  end 
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user?(user)
    user == current_user
  end  
  #this code remembers keeps the session for current user active when he visits another page
  def current_user
     if (user_id = session[:user_id])
        @current_user ||= User.find_by(id:user_id)
      elsif (user_id = cookies.signed[:user_id])
        user = User.find_by(id:user_id)
        if user && user.authenticated?(cookies[:remember_token])
          sign_in user
          @current_user = user
        end
    end
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
    #added 
  end
  #this fixes the bug where user is remembered after signout
def forget
  user.forget
  cookies.delete(:user_id)
  cookies.delete(:remember_token)
end  
#clearing remeber cookies for security reasons, it doesnt clear cookies and breaks the code?
  def sign_out
    #forget(current_user)
    self.current_user = nil
    cookies.delete(:remember_token)
  end
  #friendly forwarding
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end
  
  def store_location 
    #remembers where user was before he/she got redirected to sign in page
    #where request.fullpath is the value
    session[:return_to] = request.fullpath
  end    
end
