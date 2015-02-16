module SessionsHelper
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user;
  end
  
  def signed_in?
    #note if you dont do the negation of current_user going back to the home page
    #still shows that we are logged in if we access accounts directly
    #we might not want this in some case because it still shows account link on the homepage
   !current_user.nil?
  end 
  
  def current_user=(user)
    @current_user = user
  end
  
  #this code remembers keeps the session for current user active when he visits another page
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end  

#clearing remeber cookies for security reasons
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
end
