class AttendanceController < ApplicationController
  

   # 出勤/退勤（ボタン押下用）
  def attendance_update
    # 更新する勤怠データを取得
    @attendance = Attendance.find(params[:attendance][:id])
    # 更新パラメータを文字列で取得する
    @update_type = params[:attendance][:update_type]
    
    if @update_type == 'attendance_time'
      # 出社時刻を更新 @note 秒数以下は切り捨て
      if !@attendance.update_column(:attendance_time, Time.at((DateTime.current.to_i / 60) * 60))
        flash[:error] = "出社時間の入力に失敗しました"
      end
    elsif @update_type == 'leaving_time'
      # 退社時刻を更新 @note 秒数以下は切り捨て　15分区切りの切り捨て
      if !@attendance.update_column(:leaving_time, Time.at((DateTime.current.to_i / 60) * 60))
        flash[:error] = "退社時間の入力に失敗しました"
      end
    end  

    @user = User.find(params[:attendance][:user_id])
    redirect_to @user
  end
   
  def attendance_edit
    #if current_user.admin?
     # redirect_to :action => 'index'
    #end
    if current_user
    @user = User.find(params[:id])
    end    
    # 曜日表示用に使用する
    @youbi = %w[日 月 火 水 木 金 土]

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
        attend = Attendance.create(user_id: @user.id, day:date)
        attend.save
      end
    end
    # 表示期間の勤怠データを日付順にソートして取得
    @attendances = @user.attendances.where('day >= ? and day <= ?', @first_day, @last_day).order("day ASC")
  end
  
  def update_all
   @user = User.find(params[:id])  
   params[:attendance].each do |id, item|
      attendance = Attendance.find(id)

      if item["attendance_time(4i)"].blank? && item["leaving_time(4i)"].blank? 
        attendance.update_attributes(attendance_time: nil, leaving_time: nil)
      elsif !item["attendance_time(4i)"].blank? && !item["leaving_time(4i)"].blank? 
      # 両方の入力がされた時、出勤・退勤時刻を表記
        attendance.update_attributes(item.permit(:remarks, :attendance_time, :leaving_time))  
      elsif  item["attendance_time(4i)"].blank? ^ item["leaving_time(4i)"].blank?
      # 出社または退社のどちらか一方にか入力がされてないときは、nilを返す
        flash[:danger] = "出社時刻と退社時刻の両方を入力して下さい！" 
        attendance.update_attributes(attendance_time: nil, leaving_time: nil)
      end
   end
     
   
   redirect_to user_url(@user, params: { id: @user.id, first_day: params[:first_day] })
  end 

end
