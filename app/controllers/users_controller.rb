class UsersController < ApplicationController
  before_action :work_management_user, only: [:index, :edit, :update, :destroy]
  before_action :admin_or_correct_user, only: [:index, :edit, :update]
  before_action :admin_user,   only: [:index, :destroy]
  
  
  def index
   @users = User.paginate(page: params[:page]).search(params[:search])
  end
  
  def attendance_index
    @attendance_users = {}
    User.all.each do |attendance_user|
      if attendance_user.attendances.any?{|a|
       ( a.day == Date.today && !a.attendance_time.blank? && a.leaving_time.blank? ) }
      @attendance_users[attendance_user.employee_number] = attendance_user.name
      end
    end  
  end
  
  def show_confirm
    @user = User.find(params[:id])
   
    redirect_to user_url(@user, params: { id: @user.id, first_day: params[:first_day] })
  end
  
  # Get /users/:id
  def show
    #=> app/views/users/show.html
    @user = User.find(params[:id])
    #上長ユーザを全取得し、上長のみを取得
    @superior_users = User.where.not(id: @user.id, superior: false)
  
    #http://railsdoc.com/references/where(配列で指定)    
    # 残業申請一覧を取得
    @overwork_check = Attendance.where("over_time_state= '1' ")
    @overtime_applications = @overwork_check.group_by do |application|
      User.find_by(id: application.user_id).name
    end
    
    #1ヶ月分の勤怠情報を取得
    @one_month_work_check = OneMonthWork.where("application_state= '1' ")
    @one_month_applications = @one_month_work_check.group_by do |application|
      User.find_by(id: application.app_user_id).name
    end
  
    #勤怠変更一覧を取得
     @edit_overwork_check = Attendance.where("over_time_edit_state= '1' ")
     @edit_applications = @edit_overwork_check.group_by do |application|
       User.find_by(id: application.user_id).name
     end

    # 曜日表示用に使用する
    @youbi = %w[日 月 火 水 木 金 土]
    
    #基本情報
    @basic_info = BasicInfo.find_by(id: 1)
  
    # 既に表示月があれば、表示月を取得する
    if !params[:first_day].nil?
      #https://techacademy.jp/magazine/18710
      @first_day = Date.parse(params[:first_day])
    else
      # 表示月が無ければ、今月分を表示
      @first_day = Date.new(Date.today.year, Date.today.month, 1)
    end
    #最終日を取得する
    @last_day = @first_day.end_of_month

    # 今月の初日から最終日の期間分を取得
    (@first_day..@last_day).each do |date|
      # 該当日付のデータがないなら作成する
      #(例)user1に対して、今月の初日から最終日の値を取得する
      #https://udemy.benesse.co.jp/development/ruby-array.html 
      if !@user.attendances.any? {|attendance| attendance.day == date }
        linked_attendance = Attendance.create(user_id: @user.id, day: date)
        linked_attendance.save
      end
    end
    
    # 自身の所属長承認状態取得
    @one_month_attendance = OneMonthWork.find_by(app_user_id: @user.id, app_date: @first_day)  
  
    #申請用に新規作成
    @new_one_month_attendance = OneMonthWork.new(app_user_id: @user.id)
  
    # 表示期間の勤怠データを日付順にソートして取得 show.html.erb、 <% @attendances.each do |attendance| %>からの情報
    # モデル.where.not(条件) ※WHEREと一緒に使用し、条件式に一致しないものを取得する
    # User.where.not("name = 'Jon'")
    # SELECT * FROM users WHERE NOT (name = 'Jon')
    
    #https://qiita.com/Kta-M/items/8bd941d3f61a536e21ac
    #day >= ? => day >= first_day,  day <= ? => day <= @last_day
    @attendances = @user.attendances.where('day >= ? and day <= ?', @first_day, @last_day).order("day ASC")
   
    # 出勤日数
    @attendance_days = @attendances.where.not(attendance_time: nil, leaving_time: nil).count
    # 在社時間総数
    @work_sum_hour= 0
    @work_sum_min= 0
    @attendances.where.not(attendance_time: nil, leaving_time: nil).each do |attendance|
    @work_sum_hour += (attendance.leaving_time.hour - attendance.attendance_time.hour)
    @work_sum_min += (attendance.leaving_time.min - attendance.attendance_time.min)
      if @work_sum_min >= 60
        @work_sum_hour +=1
        @work_sum_min   =0
      end  
    end

    #基本時間・指定勤務時間・総合勤務時間初期値入力
    @basic_specified_work_info = 0
    @attendance_sum_hour = 0
    @attendance_sum_hour = 0
    
    #基本時間
    @basic_work_info_hour = @user.basic_work_time.hour if !@user.basic_work_time.blank?
    @basic_work_info_min  = @user.basic_work_time.min  if !@user.basic_work_time.blank?  
    #総合勤務時間　= 出勤日数*基本時間  
    @attendance_sum_hour = @attendance_days*@basic_work_info_hour 
    @attendance_sum_min = @attendance_days*@basic_work_info_min
    
    # 検索拡張機能として.search(params[:search])を追加    
    @microposts = @user.microposts.paginate(page: params[:page]).search(params[:search])
  end
  
  # GET /users/new
  def new
   @user = User.new
   # => form_for @user
  end
  
  #CSVファイル出力
  def attendance_table
    #=> app/views/users/show.html
    @user = User.find(params[:id])
    
    # 曜日表示に使用する
    @youbi = %w[日 月 火 水 木 金 土]
    
    #基本情報
    @basic_info = BasicInfo.find_by(id: 1)
    
     # 既に表示月があれば、表示月を取得する
    if !params[:first_day].nil?
      @first_day = Date.parse(params[:first_day])
    else
      # 今月分を表示
      @first_day = Date.new(Date.today.year, Date.today.month, 1)
    end
    #最終日を取得する
    @last_day = @first_day.end_of_month
    
    # 表示期間の勤怠データを日付順にソートして取得 show.html.erb、 <% @attendances.each do |attendance| %>からの情報
    @attendances = @user.attendances.where('day >= ? and day <= ?', @first_day, @last_day).order("day ASC")
    # 出勤日数
    @attendance_days = @attendances.where.not(attendance_time: nil, leaving_time: nil).count
    # 在社時間総数
    @work_sum = 0
    @attendances.where.not(attendance_time: nil, leaving_time: nil).each do |attendance|
      @work_sum += attendance.leaving_time - attendance.attendance_time
    end
    @work_sum /= 3600
    
    # CSV出力ファイル名を指定
    respond_to do |format|
      format.csv do
        send_data render_to_string, filename: "#{@first_day.strftime("%Y年%m月")}_#{@user.name}.csv", type: :csv
      end
    end
  end
  
  # Post /users
  def create
    @user = User.new(user_params)
    if @user.save
      #Success
      #@user.send_activation_email
      log_in @user
      flash[:info] = "ユーザー登録が完了しました"
      redirect_to @user
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
    if @user.update_attributes(user_params) 
      #Success
      flash[:success] = "ユーザー情報を更新しました"
      if current_user.admin?
        redirect_to users_path
      else
        redirect_to @user
      end  
    else
      #Failure
      # => @user.errors.full_messages
      redirect_to 'edit'
    end
  end
  
  # 基本情報の編集
  # get '/basic_info',   to: 'users#edit_basic_info'
  def edit_basic_info
    # 管理者用の基本情報を取得
    @basic_info = BasicInfo.find_by(id: 1)
    # 基本情報のnilであれば、新規に作成(初期状態)
    if @basic_info.nil?
      @basic_info = BasicInfo.new
      @basic_info.save
    end
  end
  
  # 基本情報の更新
  def update_basic_info
    # 1つしかないので先頭を更新
    @basic_info = BasicInfo.find_by(id: 1)
    if @basic_info.update_attributes(basic_info_params) && !@basic_info.basic_work_time.blank? && !@basic_info.specified_work_time.blank?
      #Success
      flash[:success] = "基本情報を更新しました"
      redirect_to current_user
    elsif @basic_info.basic_work_time.blank?  && @basic_info.specified_work_time.blank?
      #Failure
      flash[:danger] = "指定勤務時間及び基本勤務時間を更新して下さい"
      redirect_to basic_info_path
    elsif @basic_info.basic_work_time.blank?  && !@basic_info.specified_work_time.blank?
      #Failure
      flash[:danger] = "基本勤務時間を更新して下さい"
      redirect_to basic_info_path
     elsif !@basic_info.basic_work_time.blank?  && @basic_info.specified_work_time.blank?
      #Failure
      flash[:danger] = "指定勤務時間を更新して下さい"
      redirect_to basic_info_path
    end
  end
  
  # 1ヵ月分の勤怠申請
  def onemonth_application
    @user = User.find_by(id: params[:one_month_work][:app_user_id])
    
    # 上長の申請先が空の場合
    if params[:one_month_work][:auth_user_id].blank?
      flash[:danger] = "所属長の指定をしてくだい"
      redirect_to user_url(@user, params: { id: @user.id, first_day: params[:one_month_work][:first_day] })
      return
    end
    
    @one_month_work = OneMonthWork.find_by(app_user_id: params[:one_month_work][:app_user_id], app_date: params[:one_month_work][:app_date])
    if @one_month_work.nil?
      @one_month_work = OneMonthWork.new(one_month_attendance_params)
      if !@one_month_work.save
        flash[:error] = "所属長承認の申請に失敗しました"
        redirect_to user_url(@user, params: { id: @user.id, first_day: params[:one_month_work][:first_day] })
        return
      end
    else
      if !@one_month_work.update_attributes(one_month_attendance_params)
        flash[:error] = "所属長承認の申請に失敗しました"
        redirect_to user_url(@user, params: { id: @user.id, first_day: params[:one_month_work][:first_day] })
        return
      end
    end    
      
    # 申請者の番号も保持
    @one_month_work.applying!
    @user.update_attributes(applied_user_id: @one_month_work.auth_user_id)
    flash[:success] = "所属長承認申請しました"
    redirect_to user_url(@user, params: { id: @user.id, first_day: params[:one_month_work][:first_day] })
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
  
  def import
    # ファイルセットされていたら保存と結果のメッセージを取得して表示
    if !params[:file].blank?
      # 保存と結果のメッセージを取得して表示
      User.import(params[:file])
      flash[:success] = "CSVファイルを読み込みました"
    else
      flash[:notice] = "読み込むCSVファイルをセットしてください"
    end
    redirect_to users_path
  end

  
  private
    def user_params
      params.require(:user).permit(
        :name, :email, :affiliation, :remarks,
        :password, :password_confirmation, :attendance_time, :card_id, :basic_work_time, :employee_number,
        :specified_work_start_time, :specified_work_end_time)
    end
    
    def basic_info_params
      params.require(:basic_info).permit(:basic_work_time, :specified_work_time)
    end
    
    def one_month_attendance_params
      params.require(:one_month_work).permit(:app_user_id, :auth_user_id, :app_date, :app_state)
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
  # 正しいユーザーor管理者か��うか確認
    def admin_or_correct_user
      @user = User.find(params[:id])
      if !current_user?(@user) && !current_user.admin?
        redirect_to(root_url)
      end
    end

end
