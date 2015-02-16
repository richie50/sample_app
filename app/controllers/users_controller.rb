class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end
  
  def create
	@user = User.new(params[:user])
  	if @user.save
	  #Suucess creating account
	    sign_in @user #signs in the user upon sign up
	    flash[:success] = "Welcome to the Forum Page for CSE 3482"
	    redirect_to @user
	 else
	   render 'new'
	end     
  end

end
