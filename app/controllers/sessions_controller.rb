class SessionsController < ApplicationController
  
  def new
    #code
  end
  
  def create
    #find user by session with email note user already exist in the database
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #then user exist give access
      sign_in user
      #remember user
      #friendly forwarding
      redirect_back_or user
      
    else
      flash.now[:error] = 'Invalid email or password'
       render 'new'
    end 
  end
  
  def destroy
    #when user clicks on the sign out from the drop down menu
    #sign_out if signed_in?
    sign_out
    redirect_to root_path
  end

end
