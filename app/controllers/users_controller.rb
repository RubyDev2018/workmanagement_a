class UsersController < ApplicationController
  # Get /users/:id
  def show
    #=> app/views/users/show.html
    @user = User.find(params[:id])
  end
  
  def new
   @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      #Success
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
      # GET "/users/#{@user.id}" =>Show
    else
      #Failure
      render 'new'
    end
  end  
  
  def user_params
    params.require(:user).permit(
      :name, :email, :password, 
      :password_confirmation)
  end
end

