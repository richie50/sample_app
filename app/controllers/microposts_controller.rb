class MicropostsController < ApplicationController
  #code
  before_filter :signed_in_user, only: [:create, :destroy]
  def index
    #code
  end
  def create
    #code
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Post Created!"
      redirect_to root_path
    else
      render 'static_pages/home'
    end  
  end
  def destroy
    #code 
  end
end