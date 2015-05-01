class UsersController < ApplicationController
   before_filter :signed_in_user, only: [:index, :edit , :update, :destroy]
   before_filter :legit_user, only: [:edit , :update]    
  before_filter :admin_user, only: :destroy
  
  def index
    #index page for all user in the database
    #pull out all users from the model with the instance variable
    #@users = User.paginate(page: params[:page])
    @users = User.all
  end
  
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
  
  def edit
    #edit page controller
    @user = User.find(params[:id]) #get the current user
  end
  
  def update
    # method deals with updating users
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      #update successful stay on page
      sign_in @user
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
    
  end
  
  def destroy
    #admin code to delete user
    @user = User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end
 
  private
  def user_params
    #code
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def signed_in_user
    #code allows only authourized individuals to access edit page if not it saves the session
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."
     end 
  end
  
   def legit_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
    def admin_user
    redirect_to(root_path) unless current_user.admin?
 end
end
