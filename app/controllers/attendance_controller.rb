class AttendanceController < ApplicationController
   before_action :work_management_user
  
  def attendance_display
   if logged_in?
     @user  = current_user 
   end
   #コメントアウト
    # @first_day = Time.current.beginning_of_month.to_datetime 
    # @last__day = Time.current.end_of_month.to_datetime 
  
   @attenadnce = Attendance.new 
   @attendance = Attendance.create
   #@attendance = Attendance.find(1)
   # findがないと、出社、退社時刻両方が反映されない
  
    
    ##「出社」「退社」の処理
    #「出社」ボタン押下
    if params[:attendance]=="attendance_time"
       @attendance.update_column(:attendance_time, Time.current)
       @attendance.update_column(:day, Time.current)
       @attendance.save
    elsif params[:attendance] == 'leaving_time'
       @attendance.update_column(:leaving_time, Time.current)
       @attendance.update_column(:day, Time.current)
       @attendance.save
    end  
  
    # 表示月があれば取得
    if !params[:first_day].nil?
      @first_day = Date.parse(params[:first_day])
    else
      # 表示月がなければ今月分を表示する
      @first_day = Date.new(Date.today.year, Date.today.month, 1)
    end
     #今月末のデータを取得
     @last_day = @first_day.end_of_month
  end
   
  def attendance_edit
    if logged_in?
     @user  = current_user 
    end
   @attenadnce = Attendance.new 
   @attendance = Attendance.create
   
     # 表示月があれば取得する
    if !params[:first_day].nil?
      @first_day = Date.parse(params[:first_day])
    else
      # 表示月がなければ今月分を表示する
      @first_day = Date.new(Date.today.year, Date.today.month, 1)
    end
     #今月末のデータを取得
     @last_day = @first_day.end_of_month
  end
  
end