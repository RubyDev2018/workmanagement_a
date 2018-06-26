class AttendanceController < ApplicationController
  
  # 出勤・退社ボタン押下　show.html.erbの出社・退社押下時反応
  def attendance_update
    # 更新する勤怠データを取得
    @attendance = Attendance.find(params[:attendance][:id])
    # 更新パラメータを文字列で取得する
    @update_type = params[:attendance][:update_type]
    
    if @update_type == 'attendance_time'
      # 出社時刻を更新 
      if !@attendance.update_column(:attendance_time, Time.current)
        flash[:error] = "出社時間の入力に失敗しました"
      end
    elsif @update_type == 'leaving_time'
      # 退社時刻を更新 
      if !@attendance.update_column(:leaving_time, Time.current)
        flash[:error] = "退社時間の入力に失敗しました"
      end
    end  
    #出社・退社押下した日付及び現在のuser idを@userに返す
    @user = User.find(params[:attendance][:user_id])
    redirect_to @user
  end
   
  def attendance_edit
    if current_user
    @user = User.find(params[:id])
    end    
    # 曜日表示用に使用する
    @youbi = %w[日 月 火 水 木 金 土]

     # 既に表示月があれば、表示月を取得する
    if !params[:first_day].nil?
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
      if !@user.attendances.any? {|attendance| attendance.day == date }
        linked_attendance = Attendance.create(user_id: @user.id, day: date)
        linked_attendance.save
      end
    end
    #development.sqlite3を参照
    # 表示期間のデータを日付順にソートして取得
    @attendances = @user.attendances.where('day >= ? and day <= ?', @first_day, @last_day).order("day ASC")
  end
  
  def update_all
   @user = User.find(params[:id])  
   #当月の各日付ごとに出社時間及び退社時間をチェックする
   params[:attendance].each do |id, item|
    attendance = Attendance.find(id)
    
    # 出勤・退社時間がblankであれば、出勤・退社時刻にnilを返す
    if item["attendance_time(4i)"].blank? && item["leaving_time(4i)"].blank? 
      attendance.update_attributes(attendance_time: nil, leaving_time: nil)
    # 出勤・退社時間が表記されていれば、備考・出勤・退社時刻を入力する  
    elsif !item["attendance_time(4i)"].blank? && !item["leaving_time(4i)"].blank? 
      flash[:success] = "出社・退社時刻が反映されました！"
      attendance.update_attributes(item.permit(:remarks, :attendance_time, :leaving_time))  
    # 出社または退社のどちらか一方に値か入力がされてないときは、nilを返す(EXOR)  
    elsif  item["attendance_time(4i)"].blank? ^ item["leaving_time(4i)"].blank?
      flash[:danger] = "出社時刻と退社時刻の両方を入力して下さい！" 
      attendance.update_attributes(attendance_time: nil, leaving_time: nil)
    end
  end
   #user_urlにて、当該ユーザーの今月月を表示   
   redirect_to user_url(@user, params: { id: @user.id, first_day: params[:first_day] })
  end 

end
