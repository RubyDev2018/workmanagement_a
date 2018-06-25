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
    
    # 曜日表示用に使用する
    @youbi = %w[日 月 火 水 木 金 土]
   
     # 基本情報取得
    @basic_info = BasicInfo.find_by(id: 1)
   
    # 表示月があれば取得する
    if !params[:first_day].nil?
      @first_day = Date.parse(params[:first_day])
    else
      # ないなら今月分を表示する
      @first_day = Date.new(Date.today.year, Date.today.month, 1)
    end
    @last_day = @first_day.end_of_month

    # 期間分のデータチェック
    (@first_day..@last_day).each do |date|
      # 該当日付のデータがないなら作成する
      if !@user.attendances.any? {|attendance| attendance.day == date }
        attend = Attendance.create(user_id: @user.id, day: date)
        attend.save
      end
    end
    
    # 表示期間の勤怠データを日付順にソートして取得
    @attendances = @user.attendances.where('day >= ? and day <= ?', @first_day, @last_day).order("day ASC")
    # 出勤日数を取得
    @attendance_days = @attendances.where.not(attendance_time: nil, leaving_time: nil).count
    # 在社時間総数
    @work_sum = 0
    @attendances.where.not(attendance_time: nil, leaving_time: nil).each do |attendance|
      @work_sum += attendance.leaving_time - attendance.attendance_time
    end
    @work_sum /= 3600
    
    
    #総合勤務時間　= 出金日数*基本時間
    @attendance_sum = 0
    @basic_infos = 0
    @basic_infos = ((@basic_info.basic_work_time.hour*60.0) + @basic_info.basic_work_time.min)/60 if !@basic_info.basic_work_time.blank?
    @attendance_sum = @attendance_days* @basic_infos   

    # 検索拡張機能として.search(params[:search])を追加    
    @microposts = @user.microposts.paginate(page: params[:page]).search(params[:search])
  end
  
  # GET /users/new
  def new
   @user = User.new
   # => form_for @user
   @basic_info = BasicInfo.new
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
    if @user.update_attributes(user_params) && 
      #Success
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to current_user
    else
      #Failure
      # => @user.errors.full_messages
      redirect_to current_user
    end
  end
  
  # 基本情報の編集
  def edit_basic_info
    # 1つしかないので先頭を取得
    @basic_info = BasicInfo.find_by(id: 1)
   
    # なければ作成する
    if @basic_info.nil?
      @basic_info = BasicInfo.new
      @basic_info.save
    end
  end
  
  # 基本情報の更新
  def update_basic_info
    # 1つしかないので先頭を更新
    @basic_info = BasicInfo.find_by(id: 1)
    if @basic_info.update_attributes(basic_info_params) && !@basic_info.basic_work_time.blank?
      #Success
      flash[:success] = "基本情報を更新しました"
      redirect_to current_user
    else 
      #Failure
      flash[:danger] = "基本情報を更新して下さい"
      redirect_to current_user
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
  
  
  private
    def user_params
      params.require(:user).permit(
        :name, :email, :affiliation, :remarks,
        :password, :password_confirmation, :attendance_time)
    end
    
    def basic_info_params
      params.require(:basic_info).permit(:basic_work_time, :specified_work_time)
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
