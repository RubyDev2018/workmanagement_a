class UsersController < ApplicationController
  before_action :work_management_user, only: [:index, :edit, 
                                       :update, :destroy,
                                       :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]
  
  def index
   @users = User.where(activated: true).paginate(page: params[:page]).search(params[:search])
  end
  
  # Get /users/:id
  def show
    #=> app/views/users/show.html
    @user       = User.find(params[:id])
    # 検索拡張機能として.search(params[:search])を追加    
    @microposts = @user.microposts.paginate(page: params[:page]).search(params[:search])
  end
  
  # GET /users/new
  def new
   @user = User.new
   # => form_for @user
  end
  
  # Post /users
  def create
    @user = User.new(user_params)
    if @user.save
      #Success
      @user.send_activation_email
      flash[:info] = "RUN CLUBより送られてくるメールをご確認下さい"
      redirect_to root_url
    else
      #Failure
      render 'new'
    end
  end  
  
  #GET /users/:id/edit
  #params[:id] => :id
  def edit
    @user = User.find(params[:id])
    # app/views/users/edit.html.erb
  end
  
  # PATCH /users/:id
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #Success
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to attendance_display_path
    else
      #Failure
      # => @user.errors.full_messages
      render 'edit'
    end
  end
  
  # DELETE /users/:id
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーが削除されました"
    redirect_to users_url
  end
  
  def following
    @title = "フォロー"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  # 基本情報の更新
  def update_basic_info
    # 1つしかないので先頭を更新
    @basic_info = Basicinfo.find_by(id: 1)
  end
  
  
  
  private
    def user_params
      params.require(:user).permit(
        :name, :email, :affiliation, :remarks,
        :password, :password_confirmation, :attendance_time)
    end
    
    # ログイン済みユーザーかどうか確認
      def work_management_user
        unless logged_in?
         #GET   /users/:id/edit 
         #PATCH /users/:
         # => GET /users/:id
          store_location
          flash[:danger] = "ログインして下さい"
          redirect_to login_url
        end
      end
  
  # 正しいユーザーかどうか確認
    def correct_user
      #GET   /users/:id/edit 
      #PATCH /users/:id
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
  
  # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
end
